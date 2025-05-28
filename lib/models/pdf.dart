import 'package:flutter/services.dart';

class Pdf {
  Pdf({
    required this.pdfName,
    required this.pdfPath,
    required this.thumbnailBytes,
    required this.dateModified,
    required this.editableText,
  });
  final String pdfName;
  final String pdfPath;
  final Uint8List thumbnailBytes;
  final DateTime dateModified;
  final String editableText;
}
