import 'dart:io';
import 'package:docu_ai_app/core/global_providers/pdf_provider.dart';
import 'package:docu_ai_app/core/global_providers/scanned_image_service_provider.dart';
import 'package:docu_ai_app/core/global_providers/tab_provider.dart';
import 'package:docu_ai_app/shared/widgets/pdf_thumbnail_button.dart';
import 'package:docu_ai_app/features/home/widgets/rounded_button.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool floatingButtonCentered = false;
  int timeOnCenter = 0;

  @override
  void initState() {
    super.initState();
    Stream.periodic(
      Duration(seconds: 1),
    ).listen(
      (event) {
        if (floatingButtonCentered) {
          timeOnCenter += 1;
          if (timeOnCenter == 5) {
            setState(() {
              floatingButtonCentered = !floatingButtonCentered;
              timeOnCenter = 0;
            });
          }
        }
      },
    );
  }

  Future<void> uploadPicture() async {
    final scanner = ref.read(scannedImageServiceProvider);
    final pickedImage = await scanner.uploadPicture();
    if (pickedImage != null) {
      context.push('/preview-image', extra: pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final pdfs = ref.watch(pdfProvider);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Docu AI',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/settings');
            },
            icon: Icon(Icons.settings),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: Durations.medium1,
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return SlideTransition(
              position: Tween(begin: Offset(0, 2), end: Offset(0, 0))
                  .animate(animation),
              child: child);
        },
        child: !floatingButtonCentered
            ? Padding(
                padding: EdgeInsets.only(left: width * 0.7),
                child: FloatingActionButton(
                  key: ValueKey(true),
                  onPressed: () {
                    floatingButtonCentered = true;
                    setState(() {});
                  },
                  child: Icon(Icons.add),
                ),
              )
            : FloatingActionButton.extended(
                key: ValueKey(false),
                onPressed: () {
                  ref.read(tabProvider.notifier).state = 1;
                  timeOnCenter = 0;
                  setState(() {});
                },
                label: Row(
                  spacing: 10,
                  children: [
                    Text('Scan Document',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                    Icon(Icons.add_box_outlined),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
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
              spacing: 20,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: width * 0.08,
                    right: width * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedButton(
                            icon: Icons.add_a_photo_outlined,
                            onPressed: () {
                              ref.read(tabProvider.notifier).state = 1;
                            },
                          ),
                          RoundedButton(
                            icon: Icons.file_upload_outlined,
                            onPressed: uploadPicture,
                          ),
                        ],
                      ),
                      Text(
                        'Recently Scanned',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    if (pdfs.isEmpty) {
                      return Center(
                        child: Text('No Files Added Yet!'),
                      );
                    }
                    return child!;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 5,
                      children: [
                        ...List.generate(
                          pdfs.length < 10 ? pdfs.length : 10,
                          (index) {
                            final pdf = pdfs[index];
                            final file = File(pdf.pdfPath);
                            return Row(
                              children: [
                                if (index == 0)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.08),
                                  ),
                                InkWell(
                                  onTap: () async {
                                    context.push('/preview-pdf', extra: pdf);
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future: file.exists(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator(
                                            strokeWidth: 7,
                                            strokeCap: StrokeCap.round,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          );
                                        }

                                        return PdfThumbnailButton(pdf: pdf);
                                      },
                                    ),
                                  ),
                                ),
                                if (index == pdfs.length - 1)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.08),
                                  ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
