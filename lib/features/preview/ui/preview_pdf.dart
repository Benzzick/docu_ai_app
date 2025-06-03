import 'dart:io';

import 'package:docu_ai_app/core/global_providers/pdf_provider.dart';
import 'package:docu_ai_app/features/preview/widgets/rounded_icon_button.dart';
import 'package:docu_ai_app/features/preview/widgets/rounded_text_button.dart';
import 'package:docu_ai_app/models/pdf.dart';
import 'package:docu_ai_app/shared/widgets/back_button_app_bar.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class PreviewPdf extends ConsumerStatefulWidget {
  const PreviewPdf({super.key, required this.pdf});

  final Pdf pdf;

  @override
  ConsumerState<PreviewPdf> createState() => _PreviewPdfState();
}

class _PreviewPdfState extends ConsumerState<PreviewPdf> {
  late TextEditingController titleEditController;
  late TextEditingController documentEditController;
  late PdfController pdfController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    titleEditController = TextEditingController(text: widget.pdf.pdfName);
    pdfController = PdfController(
      document: PdfDocument.openFile(widget.pdf.pdfPath),
    );
  }

  Future<void> saveTitle() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isSaving = true;
    });
    await ref.read(pdfProvider.notifier).editPdf(
          Pdf(
            id: widget.pdf.id,
            pdfName: titleEditController.text,
            pdfPath: widget.pdf.pdfPath,
            thumbnailBytes: widget.pdf.thumbnailBytes,
            dateModified: DateTime.now(),
            editableText: widget.pdf.editableText,
          ),
        );
    setState(() {
      isSaving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved Title!'),
      ),
    );
  }

  void deletePdf() {
    ref.read(pdfProvider.notifier).deletePdf(widget.pdf);
    context.pop();
  }

  void sharePdf() async {
    final params = ShareParams(
      files: [
        XFile(widget.pdf.pdfPath),
      ],
    );
    await SharePlus.instance.share(params);
  }

  Future<String?> savePdfToDownloads(
      Uint8List pdfBytes, String fileName) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PDF',
      fileName: fileName,
      bytes: pdfBytes,
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    return outputFile;
  }

  void export() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Options'),
        content: Text('Choose what you want to do with the document:'),
        actions: [
          TextButton(
            onPressed: () async {
              final outputFile = await savePdfToDownloads(
                  await File(widget.pdf.pdfPath).readAsBytes(),
                  '${widget.pdf.pdfName}.pdf');
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: outputFile != null
                        ? Text('Saved File')
                        : Text('Did not save file')),
              );
            },
            child: Text('Export to PDF'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              Clipboard.setData(ClipboardData(text: widget.pdf.editableText));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Text copied to clipboard!')),
              );
            },
            child: Text('Copy Text'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FloatingBubbles.alwaysRepeating(
              noOfBubbles: 15,
              colorsOfBubbles: [Theme.of(context).colorScheme.secondary],
              sizeFactor: 0.2,
              opacity: 50,
              paintingStyle: PaintingStyle.fill,
              strokeWidth: 8,
              shape: BubbleShape.circle,
              speed: BubbleSpeed.normal,
            ),
          ),
          Column(
            children: [
              BackButtonAppBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text('Title:'),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: titleEditController,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    RoundedTextButton(
                        text: 'Save Title',
                        onPressed: titleEditController.text.trim() ==
                                    widget.pdf.pdfName.trim() ||
                                titleEditController.text.trim().isEmpty
                            ? null
                            : saveTitle),
                  ],
                ),
              ),
              Expanded(
                child: PdfView(
                  controller: pdfController,
                  scrollDirection: Axis.vertical,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Theme.of(context).colorScheme.secondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundedIconButton(
                      icon: Icons.edit_square,
                      onPressed: () {
                        context
                            .push('/edit-pdf', extra: widget.pdf)
                            .then((_) async {
                          final newDoc =
                              PdfDocument.openFile(widget.pdf.pdfPath);
                          await pdfController.loadDocument(newDoc);
                          setState(() {});
                        });
                      },
                    ),
                    RoundedIconButton(
                      icon: Icons.share_rounded,
                      onPressed: sharePdf,
                    ),
                    RoundedIconButton(
                      icon: Icons.ios_share_rounded,
                      onPressed: export,
                    ),
                    RoundedIconButton(
                      icon: Icons.delete_outline_rounded,
                      onPressed: deletePdf,
                    )
                  ],
                ),
              )
            ],
          ),
          if (isSaving)
            Positioned.fill(
              child: Container(
                color: Theme.of(context).colorScheme.primary.withAlpha(120),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
