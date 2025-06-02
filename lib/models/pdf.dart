import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class Pdf {
  Pdf({
    String? id,
    required this.pdfName,
    required this.pdfPath,
    required this.thumbnailBytes,
    required this.dateModified,
    required this.editableText,
  }) : id = id ?? const Uuid().v4();
  final String id;
  final String pdfName;
  final String pdfPath;
  final Uint8List thumbnailBytes;
  final DateTime dateModified;
  final String editableText;
}
