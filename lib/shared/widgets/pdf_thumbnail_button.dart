import 'package:docu_ai_app/models/enums.dart';
import 'package:docu_ai_app/models/pdf.dart';
import 'package:docu_ai_app/shared/utils/streams.dart';
import 'package:flutter/material.dart';

class PdfThumbnailButton extends StatelessWidget {
  const PdfThumbnailButton({super.key, required this.pdf});

  final Pdf pdf;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.memory(
              pdf.thumbnailBytes,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          pdf.pdfName,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        StreamBuilder<String>(
            stream: dateModifiedStream(pdf.dateModified, DateFormat.long),
            builder: (context, snapshot) {
              return Text(snapshot.data ?? 'Yes');
            }),
      ],
    );
  }
}
