import 'dart:io';
import 'package:docu_ai_app/models/pdf.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:pdfx/pdfx.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

final pdfProvider =
    StateNotifierProvider<PDFNotifier, List<Pdf>>((ref) => PDFNotifier());

class PDFNotifier extends StateNotifier<List<Pdf>> {
  PDFNotifier() : super([]) {
    loadPdfs();
  }

  Future<Database> _getPdfDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = sql.openDatabase(
      path.join(dbPath, 'pdfs.db'),
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE user_pdfs(
          id TEXT PRIMARY KEY,
          pdfName TEXT,
          pdfPath TEXT,
          thumbnailBytes BLOB,
          dateModified TEXT,
          editableText TEXT
        )
      ''');
      },
      version: 1,
    );

    return db;
  }

  Future<void> loadPdfs() async {
    final db = await _getPdfDatabase();
    final data = await db.query('user_pdfs');

    final pdfs = data.map((row) {
      return Pdf(
        id: row['id'] as String,
        pdfName: row['pdfName'] as String,
        pdfPath: row['pdfPath'] as String,
        thumbnailBytes: row['thumbnailBytes'] as Uint8List,
        dateModified: DateTime.parse(row['dateModified'] as String),
        editableText: row['editableText'] as String,
      );
    }).toList();

    state = pdfs.reversed.toList();
  }

  Future<Pdf> getFile(Uint8List bytes, String pdfText, String? fileTitle,
      String? pdfTitle) async {
    final filename = fileTitle ?? Uuid().v4();
    final fileDir = await syspath.getApplicationDocumentsDirectory();
    final db = await _getPdfDatabase();

    final file =
        File(fileTitle == null ? '${fileDir.path}/$filename.pdf' : filename);

    await file.writeAsBytes(bytes);

    final doc = await PdfDocument.openFile(file.path);

    final page = await doc.getPage(1);
    final image = await page.render(
      width: 300,
      height: 400,
      format: PdfPageImageFormat.jpeg,
    );

    final pdf = Pdf(
      pdfName: pdfTitle ?? 'Untitled',
      pdfPath: file.path,
      thumbnailBytes: image!.bytes,
      dateModified: DateTime.now(),
      editableText: pdfText,
    );

    state = [
      pdf,
      ...state,
    ];

    await db.insert('user_pdfs', {
      'id': pdf.id,
      'pdfName': pdf.pdfName,
      'pdfPath': pdf.pdfPath,
      'thumbnailBytes': pdf.thumbnailBytes,
      'dateModified': pdf.dateModified.toIso8601String(),
      'editableText': pdf.editableText,
    });

    return pdf;
  }

  Future<Pdf?> convertImgToPdf(Uint8List imageBytes) async {
    final gemini = Gemini.instance;
    String? outputText;
    try {
      final value = await gemini.prompt(parts: [
        Part.text('Get the Text iN this image all the text'),
        Part.bytes(imageBytes),
      ]);

      outputText = value?.output;
    } catch (e) {
      return null;
    }

    if (outputText == null) {
      return null;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Text(outputText!);
        },
      ),
    );

    final pdfBytes = await pdf.save();

    return getFile(pdfBytes, outputText, null, null);
  }

  Future<void> editPdf(Pdf pdfToEdit) async {
    await deletePdf(pdfToEdit);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Text(pdfToEdit.editableText);
        },
      ),
    );

    final pdfBytes = await pdf.save();

    await getFile(
      pdfBytes,
      pdfToEdit.editableText,
      pdfToEdit.pdfPath,
      pdfToEdit.pdfName,
    );
  }

  Future<void> deletePdf(Pdf pdfToDelete) async {
    final db = await _getPdfDatabase();
    state = state.where(
      (element) {
        return element.id != pdfToDelete.id;
      },
    ).toList();

    await db.delete(
      'user_pdfs', // Table name
      where: 'id = ?', // WHERE clause
      whereArgs: [pdfToDelete.id], // WHERE arguments
    );
  }
}
