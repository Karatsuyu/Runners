import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/deliveries/presentation/providers/deliveries_provider.dart';
import '../../core/router/app_routes.dart';
import 'dart:typed_data';

import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PdfViewerScreen extends ConsumerStatefulWidget {
  final String url;
  final String? assetCover;
  final String? sourceAddress;
  const PdfViewerScreen({super.key, required this.url, this.assetCover, this.sourceAddress});

  @override
  ConsumerState<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends ConsumerState<PdfViewerScreen> {
  PdfControllerPinch? _controller;
  List<Uint8List>? _pagesBytes;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final res = await http.get(Uri.parse(widget.url)).timeout(const Duration(seconds: 30));
      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
      final bytes = res.bodyBytes;
      // Always render PDF pages to images for consistent in-app preview.
      final doc = await PdfDocument.openData(bytes);
      final count = doc.pagesCount;
      final List<Uint8List> pages = [];
      // Safety: don't render more than 50 pages to avoid OOM; adjust as needed.
      final maxPages = count > 50 ? 50 : count;
      for (var i = 1; i <= maxPages; i++) {
        final page = await doc.getPage(i);
        try {
          final pageImage = await page.render(
            width: page.width,
            height: page.height,
            format: PdfPageImageFormat.jpeg,
          );
          if (pageImage?.bytes != null) pages.add(pageImage!.bytes!);
        } catch (_) {
          // ignore rendering errors for individual pages
        }
        await page.close();
      }
      await doc.close();
      if (!mounted) return;
      setState(() {
        _pagesBytes = pages;
        _loading = false;
      });
      return;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carta'),
        actions: [
          if (widget.sourceAddress != null)
            TextButton(
              onPressed: () {
                ref.read(deliveryPrefillProvider.notifier).state = DeliveryPrefill(pickupAddress: widget.sourceAddress);
                final pickup = Uri.encodeComponent(widget.sourceAddress ?? '');
                context.go('${AppRoutes.deliveries}?pickup=$pickup');
              },
              child: const Text('Solicitar domi', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null
              ? Center(child: Text('No se pudo cargar la carta: $_error'))
              : (_pagesBytes != null
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      itemCount: _pagesBytes!.length,
                      itemBuilder: (context, index) {
                        final bytes = _pagesBytes![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                bytes,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : (_controller == null
                      ? const Center(child: Icon(Icons.picture_as_pdf_outlined, size: 96, color: Colors.grey))
                      : PdfViewPinch(controller: _controller!)))),
    );
  }
}
