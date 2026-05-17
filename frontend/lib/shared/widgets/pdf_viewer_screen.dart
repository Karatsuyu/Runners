import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String? assetCover;
  const PdfViewerScreen({super.key, required this.url, this.assetCover});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfControllerPinch? _controller;
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
      if (res.statusCode == 200) {
        final controller = PdfControllerPinch(document: PdfDocument.openData(res.bodyBytes));
        setState(() {
          _controller = controller;
          _loading = false;
        });
        return;
      }
      // Non-200 codes considered failure; but do not show snackbar — use silent fallback
    } catch (_) {
      // ignore errors silently
    }
    // If we reach here, loading failed — show a simple placeholder without error text
    setState(() {
      _error = null;
      _loading = false;
    });
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
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
            : (_controller != null
              ? (widget.assetCover != null
                  ? ListView(
                      children: [
                        Image.asset(widget.assetCover!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: PdfViewPinch(controller: _controller!),
                        ),
                      ],
                    )
                  : PdfViewPinch(controller: _controller!))
              : const Center(child: Icon(Icons.picture_as_pdf_outlined, size: 96, color: Colors.grey))),
    );
  }
}
