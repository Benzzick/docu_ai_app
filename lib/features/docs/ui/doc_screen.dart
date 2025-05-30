import 'dart:io';
import 'package:docu_ai_app/core/global_providers/pdf_provider.dart';
import 'package:docu_ai_app/features/docs/providers/list_view_provider.dart';
import 'package:docu_ai_app/features/docs/providers/sort_option_provider.dart';
import 'package:docu_ai_app/features/docs/widgets/pdf_list_view_button.dart';
import 'package:docu_ai_app/shared/widgets/pdf_thumbnail_button.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocScreen extends ConsumerStatefulWidget {
  const DocScreen({super.key});

  @override
  ConsumerState<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends ConsumerState<DocScreen> {
  late TextEditingController searchController;
  String searchQuery = '';
  List<String> sortOptions = ['Name', 'Date'];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  void search(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final allPdfs = ref.watch(pdfProvider);
    final sortByDate = allPdfs
        .where((pdf) =>
            pdf.pdfName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    final sortByName = allPdfs
        .where((pdf) =>
            pdf.pdfName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList()
      ..sort(
          (a, b) => a.pdfName.toLowerCase().compareTo(b.pdfName.toLowerCase()));

    final filtered =
        ref.watch(sortOptionProvider) == 'Date' ? sortByDate : sortByName;

    final showListView = ref.watch(listViewProvider);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Documents',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
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
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Column(
              spacing: 10,
              children: [
                SearchBar(
                  leading: Icon(Icons.search),
                  hintText: 'Search documents',
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  onChanged: search,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      value: ref.watch(sortOptionProvider),
                      items: sortOptions.map(
                        (e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        ref
                            .read(sortOptionProvider.notifier)
                            .toggleSortOption(value!);
                      },
                    ),
                    IconButton.filled(
                      onPressed: () {
                        ref.read(listViewProvider.notifier).toggleListView();
                      },
                      style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                      icon: Icon(
                        showListView
                            ? Icons.grid_view_rounded
                            : Icons.list_alt_rounded,
                      ),
                    )
                  ],
                ),
                Consumer(
                  builder: (context, ref, child) {
                    if (filtered.isEmpty) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 7,
                              strokeCap: StrokeCap.round,
                              color: Theme.of(context).colorScheme.primary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      );
                    }
                    return child!;
                  },
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 5,
                        children: [
                          ...List.generate(
                            filtered.length,
                            (index) {
                              final pdf = filtered[index];
                              final file = File(pdf.pdfPath);
                              return Column(
                                children: [
                                  if (index == 0)
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width * 0.08),
                                    ),
                                  InkWell(
                                    onTap: () async {},
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: !showListView
                                          ? null
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FutureBuilder(
                                          future: file.exists(),
                                          builder: (context, snapshot) {
                                            return showListView
                                                ? PdfListViewButton(pdf: pdf)
                                                : PdfThumbnailButton(pdf: pdf);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index == filtered.length - 1)
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
