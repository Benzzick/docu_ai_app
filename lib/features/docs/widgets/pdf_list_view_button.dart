import 'package:docu_ai_app/models/enums.dart';
import 'package:docu_ai_app/models/pdf.dart';
import 'package:docu_ai_app/shared/utils/streams.dart';
import 'package:flutter/material.dart';

class PdfListViewButton extends StatelessWidget {
  const PdfListViewButton({super.key, required this.pdf});

  final Pdf pdf;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(pdf.pdfName),
        StreamBuilder<String>(
            stream: dateModifiedStream(
              pdf.dateModified,
              DateFormat.short,
            ),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? 'Yes',
                style: Theme.of(context).textTheme.bodySmall,
              );
            }),
      ],
    );
  }
}
