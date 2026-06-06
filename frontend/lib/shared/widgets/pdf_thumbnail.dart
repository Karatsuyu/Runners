import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PdfThumbnail extends StatefulWidget {
  final String url;
  final double width;
  final double height;

  const PdfThumbnail({super.key, required this.url, this.width = double.infinity, this.height = 140});

  @override
  State<PdfThumbnail> createState() => _PdfThumbnailState();
}

class _PdfThumbnailState extends State<PdfThumbnail> {
  Uint8List? _imageBytes;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    try {
      final res = await http.get(Uri.parse(widget.url));
      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
      final doc = await PdfDocument.openData(res.bodyBytes);
      final page = await doc.getPage(1);
      final pageImage = await page.render(width: page.width, height: page.height, format: PdfPageImageFormat.jpeg);
      final bytes = pageImage?.bytes;
      await page.close();
      await doc.close();
      if (bytes == null) throw Exception('No se pudo renderizar la página');
      if (!mounted) return;
      setState(() {
        _imageBytes = bytes;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return SizedBox(width: widget.width, height: widget.height, child: const Center(child: CircularProgressIndicator()));
    if (_error != null || _imageBytes == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(child: Text('No se pudo generar vista previa')),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.memory(
        _imageBytes!,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
      ),
    );
  }
}
