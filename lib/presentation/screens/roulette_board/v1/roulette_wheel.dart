import 'package:flutter/material.dart';
import 'dart:math' as math;

class RouletteWheel extends StatefulWidget {
  const RouletteWheel({super.key});

  @override
  State<RouletteWheel> createState() => _RouletteWheelState();
}

class _RouletteWheelState extends State<RouletteWheel>
    with SingleTickerProviderStateMixin {
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

  late final AnimationController _spinController;
  final math.Random _random = math.Random.secure();
  double _startRotation = 0;
  double _targetRotation = 0;
  int? _winningNumber;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _spin() async {
    if (_isSpinning) return;

    final winningIndex = _random.nextInt(rouletteNumbers.length);
    final segmentAngle = 2 * math.pi / rouletteNumbers.length;
    final desiredRotation =
        (2 * math.pi - ((winningIndex + 0.5) * segmentAngle)) % (2 * math.pi);
    final currentRotation = _targetRotation;
    final currentRotationModulo = currentRotation % (2 * math.pi);
    final additionalRotation =
        (desiredRotation - currentRotationModulo + 2 * math.pi) % (2 * math.pi);

    setState(() {
      _isSpinning = true;
      _winningNumber = null;
      _startRotation = currentRotation;
      _targetRotation =
          currentRotation + (6 * 2 * math.pi) + additionalRotation;
    });

    await _spinController.forward(from: 0);
    if (!mounted) return;

    setState(() {
      _isSpinning = false;
      _winningNumber = rouletteNumbers[winningIndex];
    });
  }

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
    final winningNumberColor =
        _winningNumber == null ? null : getPocketColor(_winningNumber!);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: _winningNumber == null
              ? Text(
                  _isSpinning ? 'Spinning...' : 'Tap SPIN to begin',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Winning number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: winningNumberColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _winningNumber.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _spinController,
                      child: CustomPaint(
                        painter: RouletteWheelPainter(
                          rouletteNumbers: rouletteNumbers,
                          getPocketColor: getPocketColor,
                        ),
                      ),
                      builder: (context, child) {
                        final progress = Curves.easeOutCubic
                            .transform(_spinController.value);
                        final rotation = _startRotation +
                            (_targetRotation - _startRotation) * progress;
                        return Transform.rotate(
                          angle: rotation,
                          child: child,
                        );
                      },
                    ),
                  ),
                  const Positioned(
                    top: -12,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.amber,
                      size: 52,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: SizedBox(
            width: 180,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isSpinning ? null : _spin,
              icon: const Icon(Icons.casino),
              label: Text(_isSpinning ? 'SPINNING' : 'SPIN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade900,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
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
