import 'dart:io';
import 'package:docu_ai_app/models/pdf.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:pdfx/pdfx.dart';


final pdfProvider =
    StateNotifierProvider<PDFNotifier, List<Pdf>>((ref) => PDFNotifier());

class PDFNotifier extends StateNotifier<List<Pdf>> {
  PDFNotifier() : super([]) {
    getFile('assets/pdfs/pdf-1.pdf');
    getFile('assets/pdfs/pdf-2.pdf');
    getFile('assets/pdfs/pdf-3.pdf');
  }

  Future<Pdf> getFile(String url) async {
    final data = await rootBundle.load(url);
    final bytes = data.buffer.asUint8List();
    final filename = path.basename(url);
    final fileDir = await syspath.getApplicationDocumentsDirectory();

    final file = File('${fileDir.path}/$filename');

    await file.writeAsBytes(bytes);

    final doc = await PdfDocument.openFile(file.path);

    final page = await doc.getPage(1);
    final image = await page.render(
      width: 300,
      height: 400,
      format: PdfPageImageFormat.png,
    );

    final pdf = Pdf(
      pdfName: 'Learn By Me',
      pdfPath: file.path,
      thumbnailBytes: image!.bytes,
      dateModified: DateTime.now(),
      editableText: 'yessssssssssssssssssssssssssssssssssss',
    );

    state = [
      pdf,
      ...state,
    ];
    return pdf;
  }

  void editPdf(Pdf pdfToEdit) {}

  void deletePdf(Pdf pdfToDelete) {}

  
}
