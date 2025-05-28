import 'package:flutter/material.dart';

class A4ScannerOverlay extends CustomPainter {
  final Color overlayColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double padding;
  final double bottomControlsHeight;

  A4ScannerOverlay({
    this.overlayColor = Colors.black54,
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.borderRadius = 8.0,
    this.padding = 40.0,
    this.bottomControlsHeight = 120.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double a4AspectRatio = 1 / 1.414;

    // Screen dimensions
    final double screenWidth = size.width;
    final double screenHeight = size.height;
    final double availableWidth = screenWidth - (padding * 2);
    final double availableHeight =
        screenHeight - (padding * 2) - bottomControlsHeight;
    double a4Width, a4Height;

    if (availableWidth / availableHeight > a4AspectRatio) {
      a4Height = availableHeight;
      a4Width = a4Height * a4AspectRatio;
    } else {
      a4Width = availableWidth;
      a4Height = a4Width / a4AspectRatio;
    }

    // Center the A4 rectangle on screen
    final double left = (screenWidth - a4Width) / 2;
    final double top = (screenHeight - a4Height) / 2;
    final Rect scanRect = Rect.fromLTWH(left, top, a4Width, a4Height);

    // Create path for the overlay with hole
    final Path overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight))
      ..addRRect(
          RRect.fromRectAndRadius(scanRect, Radius.circular(borderRadius)))
      ..fillType = PathFillType.evenOdd;
    final overlayPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(overlayPath, overlayPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant A4ScannerOverlay oldDelegate) {
    return oldDelegate.overlayColor != overlayColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.padding != padding ||
        oldDelegate.bottomControlsHeight != bottomControlsHeight;
  }

  Rect getScanRect(Size size) {
    const double a4AspectRatio = 1 / 1.414;
    final double screenWidth = size.width;
    final double screenHeight = size.height;
    final double availableWidth = screenWidth - (padding * 2);
    final double availableHeight =
        screenHeight - (padding * 2) - bottomControlsHeight;

    double a4Width, a4Height;

    if (availableWidth / availableHeight > a4AspectRatio) {
      a4Height = availableHeight;
      a4Width = a4Height * a4AspectRatio;
    } else {
      a4Width = availableWidth;
      a4Height = a4Width / a4AspectRatio;
    }

    final double left = (screenWidth - a4Width) / 2;
    final double top = (screenHeight - a4Height) / 2;
    return Rect.fromLTWH(left, top, a4Width, a4Height);
  }
}
