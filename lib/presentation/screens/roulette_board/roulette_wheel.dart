import 'package:flutter/material.dart';
import 'dart:math' as math;

class RouletteWheel extends StatelessWidget {
  const RouletteWheel({super.key});

  // The order of numbers on a single-zero roulette wheel
  final List<int> rouletteNumbers = const [
    0,
    32,
    15,
    19,
    4,
    21,
    2,
    25,
    17,
    34,
    6,
    27,
    13,
    36,
    11,
    30,
    8,
    23,
    10,
    5,
    24,
    16,
    33,
    1,
    20,
    14,
    31,
    9,
    22,
    18,
    29,
    7,
    28,
    12,
    35,
    3,
    26
  ];

  // Function to determine the color of a number
  Color getPocketColor(int number) {
    if (number == 0) {
      return Colors.green.shade700;
    }
    // Standard roulette pocket colors (red and black)
    const Set<int> redNumbers = {
      1,
      3,
      5,
      7,
      9,
      12,
      14,
      16,
      18,
      19,
      21,
      23,
      25,
      27,
      30,
      32,
      34,
      36
    };
    if (redNumbers.contains(number)) {
      return Colors.red.shade900;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: RouletteWheelPainter(
          rouletteNumbers: rouletteNumbers,
          getPocketColor: getPocketColor,
        ),
      ),
    );
  }
}

class RouletteWheelPainter extends CustomPainter {
  final List<int> rouletteNumbers;
  final Function(int) getPocketColor;

  RouletteWheelPainter({
    required this.rouletteNumbers,
    required this.getPocketColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = math.min(size.width, size.height) / 2;
    final innerRadius = outerRadius * 0.8; // For the central hub

    // Define colors
    final Paint linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final double sweepAngle = 360 / rouletteNumbers.length;
    final double radianSweepAngle = sweepAngle * (math.pi / 180);

    // Draw the segments and numbers
    for (int i = 0; i < rouletteNumbers.length; i++) {
      final int number = rouletteNumbers[i];
      final Color segmentColor = getPocketColor(number);

      final double startAngle =
          -90 + (i * sweepAngle); // Start from top (-90 degrees)
      final double radianStartAngle = startAngle * (math.pi / 180);

      // Draw the segment arc
      final Paint segmentPaint = Paint()..color = segmentColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        radianStartAngle,
        radianSweepAngle,
        true, // Use center for filled arc
        segmentPaint,
      );

      // Draw lines separating segments
      canvas.drawLine(
        center,
        Offset(
          center.dx + outerRadius * math.cos(radianStartAngle),
          center.dy + outerRadius * math.sin(radianStartAngle),
        ),
        linePaint,
      );

      // Position and draw the number
      final double midAngle = radianStartAngle + (radianSweepAngle / 2);

      // Move the text number higher (closer to the outer edge)
      final double textX =
          center.dx + (outerRadius * 0.92) * math.cos(midAngle);
      final double textY =
          center.dy + (outerRadius * 0.92) * math.sin(midAngle);

      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: number.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      // Rotate the canvas to align the text with the segment
      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(midAngle + math.pi / 2); // Adjust for upright text
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Draw the central hub (optional, for aesthetics)
    final Paint hubPaint = Paint()..color = Colors.grey.shade800;
    canvas.drawCircle(center, innerRadius, hubPaint);
    canvas.drawCircle(center, innerRadius, linePaint); // Border for hub
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Only repaint if data changes, which it doesn't here.
  }
}
