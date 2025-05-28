import 'package:docu_ai_app/core/global_providers/pdf_provider.dart';
import 'package:docu_ai_app/features/preview/widgets/rounded_text_button.dart';
import 'package:docu_ai_app/models/pdf.dart';
import 'package:docu_ai_app/shared/widgets/back_button_app_bar.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPdf extends ConsumerStatefulWidget {
  const EditPdf({super.key, required this.pdf});

  final Pdf pdf;

  @override
  ConsumerState<EditPdf> createState() => _EditPdfState();
}

class _EditPdfState extends ConsumerState<EditPdf> {
  late TextEditingController documentEditController;

  @override
  void initState() {
    super.initState();
    documentEditController =
        TextEditingController(text: widget.pdf.editableText);
  }

  void saveDocument() {
    ref.read(pdfProvider.notifier).editPdf(
          Pdf(
            pdfName: widget.pdf.pdfName,
            pdfPath: widget.pdf.pdfPath,
            thumbnailBytes: widget.pdf.thumbnailBytes,
            dateModified: DateTime.now(),
            editableText: documentEditController.text,
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
              BackButtonAppBar(
                child: RoundedTextButton(
                    text: 'Save Document', onPressed: saveDocument),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(24),
                  width: 794,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blueAccent),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade300, blurRadius: 10),
                    ],
                  ),
                  child: TextField(
                    controller: documentEditController,
                    maxLines: null,
                    decoration: const InputDecoration.collapsed(
                        hintText: "Start typing..."),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
