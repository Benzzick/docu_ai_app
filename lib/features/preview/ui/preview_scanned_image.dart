import 'dart:io';
import 'package:docu_ai_app/core/global_providers/pdf_provider.dart';
import 'package:docu_ai_app/core/global_providers/scanned_image_service_provider.dart';
import 'package:docu_ai_app/features/preview/widgets/rounded_icon_button.dart';
import 'package:docu_ai_app/features/preview/widgets/rounded_text_button.dart';
import 'package:docu_ai_app/shared/widgets/back_button_app_bar.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PreviewScannedImage extends ConsumerStatefulWidget {
  const PreviewScannedImage({super.key, required this.image});
  final File image;

  @override
  ConsumerState<PreviewScannedImage> createState() =>
      _PreviewScannedImageState();
}

class _PreviewScannedImageState extends ConsumerState<PreviewScannedImage> {
  late File image;
  bool isConverting = false;

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  Future<void> convertImageToPdf() async {
    setState(() {
      isConverting = true;
    });

  
    await Future.delayed(const Duration(milliseconds: 100));

    final convertedPdf = await ref
        .read(pdfProvider.notifier)
        .convertImgToPdf(image.readAsBytesSync());

    setState(() {
      isConverting = false;
    });

    if (convertedPdf == null) {
      ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Did not convert image to file')),
              );
      return;
    }

    context.pushReplacement('/preview-pdf', extra: convertedPdf);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Column(
            children: [
              BackButtonAppBar(
                child: RoundedTextButton(
                  text: 'Convert',
                  onPressed: convertImageToPdf,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: FloatingBubbles.alwaysRepeating(
                          noOfBubbles: 15,
                          colorsOfBubbles: [
                            Theme.of(context).colorScheme.secondary,
                          ],
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
                          Container(
                            padding: EdgeInsets.all(30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                image,
                                key: ValueKey(image.path),
                              ),
                            ),
                          ),
                          RoundedIconButton(
                            icon: Icons.crop_rotate_rounded,
                            onPressed: () async {
                              final scanner =
                                  ref.read(scannedImageServiceProvider);
                              final croppedImage =
                                  await scanner.cropPicture(image);
                              if (croppedImage != null) {
                                setState(() {
                                  image = croppedImage;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isConverting)
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
    ));
  }
}
