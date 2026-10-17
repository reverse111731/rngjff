import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Alignment constants for the gradient background
const _startAlignment = Alignment.topLeft;
const _endAlignment = Alignment.bottomRight;

/// GradientContainer widget that provides a dark gradient background
/// for the dice game (similar to the color game's dark theme).
class GradientContainer extends StatelessWidget {
  const GradientContainer(this.color1, this.color2, {super.key});

  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _startAlignment,
              end: _endAlignment,
              colors: [color1, color2],
            ),
          ),
          child: const Center(child: DiceRoller()),
        ),
      ),
    );
  }
}

/// DiceRoller StatefulWidget managing the state of the dice and their rolls.
class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller>
    with SingleTickerProviderStateMixin {
  final _randomizer = Random();
  Timer? _rollTimer;
  bool _isRolling = false;

  // Selected number of dice (1, 2, or 3)
  int _selectedDiceCount = 1;

  // Current rolled values for each die
  List<int> _currentDiceRolls = [1];

  // Animation controller for the bounce/scale effect on dice
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.92), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.0), weight: 40),
    ]).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rollTimer?.cancel();
    _bounceController.dispose();
    super.dispose();
  }

  /// Total of all current dice values
  int get _totalValue =>
      _currentDiceRolls.fold(0, (sum, roll) => sum + roll);

  /// Generate random roll values for a given dice count
  List<int> _generateRandomRolls(int count) {
    return List.generate(count, (_) => _randomizer.nextInt(6) + 1);
  }

  /// Rolls all dice with a rapid shuffling animation (matching color game style)
  void _rollAllDice() {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
    });

    int ticks = 0;
    const maxTicks = 10;
    _rollTimer?.cancel();

    _rollTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      ticks++;
      if (ticks >= maxTicks) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _currentDiceRolls = _generateRandomRolls(_selectedDiceCount);
            _isRolling = false;
          });
          // Trigger the bounce animation on the final result
          _bounceController.forward(from: 0.0);
        }
      } else {
        if (mounted) {
          setState(() {
            _currentDiceRolls = _generateRandomRolls(_selectedDiceCount);
          });
        }
      }
    });
  }

  /// Result summary describing the roll (e.g., "Double 4!", "Triple 6!")
  String _getResultSummary() {
    if (_currentDiceRolls.isEmpty) return '';
    if (_currentDiceRolls.length == 1) {
      return 'Rolled a ${_currentDiceRolls.first}';
    }

    // Check for matching combinations
    final valueCounts = <int, int>{};
    for (final v in _currentDiceRolls) {
      valueCounts[v] = (valueCounts[v] ?? 0) + 1;
    }

    for (final entry in valueCounts.entries) {
      if (entry.value == 3) {
        return 'Triple ${entry.key}s!';
      }
      if (entry.value == 2) {
        return 'Double ${entry.key}s!';
      }
    }

    return _currentDiceRolls.map((v) => v.toString()).join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Title banner (matching color game style)
        const Text(
          'DICE GAME',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
            color: Colors.white70,
          ),
        ),

        // Radio button selector for number of dice using RadioGroup
        RadioGroup<int>(
          groupValue: _selectedDiceCount,
          onChanged: (value) {
            if (_isRolling || value == null) return;
            setState(() {
              _selectedDiceCount = value;
              _currentDiceRolls = List.generate(value, (_) => 1);
            });
          },
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  // Radio button for 1 Die
                  Flexible(
                    child: RadioListTile<int>(
                      title: Text(
                        '1 Die',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 1,
                      fillColor: WidgetStatePropertyAll(Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  // Radio button for 2 Dice
                  Flexible(
                    child: RadioListTile<int>(
                      title: Text(
                        '2 Dice',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 2,
                      fillColor: WidgetStatePropertyAll(Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  // Radio button for 3 Dice
                  Flexible(
                    child: RadioListTile<int>(
                      title: Text(
                        '3 Dice',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 3,
                      fillColor: WidgetStatePropertyAll(Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Result summary with animated transitions
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _getResultSummary(),
            key: ValueKey<String>(_getResultSummary()),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
        ),

        // Total value display
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: Text(
            'Total: $_totalValue',
            key: ValueKey<int>(_totalValue),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white60,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Display the 3D dice with bounce animation
        ScaleTransition(
          scale: _bounceAnimation,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: _currentDiceRolls.asMap().entries.map((entry) {
              return _DiceWidget(
                value: entry.value,
                isRolling: _isRolling,
              );
            }).toList(),
          ),
        ),

        // Roll button
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: _rollAllDice,
          child: Text(_isRolling ? 'Rolling...' : 'Roll Dice'),
        ),

        // Button to navigate back
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white70,
            textStyle: const TextStyle(
              fontSize: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back to selection'),
        ),
      ],
    );
  }
}

/// A 3D-styled dice widget with gradient, shadow, and dot pips
class _DiceWidget extends StatelessWidget {
  const _DiceWidget({
    required this.value,
    required this.isRolling,
  });

  final int value;
  final bool isRolling;

  // Dice face color palette
  static const _faceColor = Color(0xFFFAFAFA);
  static const _borderColor = Color(0xFFBDBDBD);

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isRolling ? 0.5 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedScale(
        scale: isRolling ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 142.5,
          height: 142.5,
          decoration: BoxDecoration(
            color: _faceColor,
            borderRadius: BorderRadius.circular(27),
            border: Border.all(
              color: _borderColor.withValues(alpha: 0.8),
              width: 4.5,
            ),
            boxShadow: [
              // Bottom drop shadow for 3D depth
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 15,
                offset: const Offset(0, 9),
              ),
              // Inner/outer ambient glow
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.15),
                blurRadius: 18,
                offset: const Offset(0, 3),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // Light highlight reflection on top
                Colors.white,
                _faceColor,
                // Darker tone at the bottom corner for cube bevel
                Colors.grey.shade300,
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
          child: Center(
            child: _DiceFace(value: value),
          ),
        ),
      ),
    );
  }
}

/// Renders the dot pips on a dice face using a grid layout
class _DiceFace extends StatelessWidget {
  const _DiceFace({required this.value});

  final int value;

  static const _dotColor = Color(0xFF212121);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 97.5,
      height: 97.5,
      child: CustomPaint(
        painter: _DiceDotPainter(value: value, dotColor: _dotColor),
      ),
    );
  }
}

/// Custom painter that draws dice dot pips in the standard arrangement
class _DiceDotPainter extends CustomPainter {
  const _DiceDotPainter({required this.value, required this.dotColor});

  final int value;
  final Color dotColor;

  static const double _dotRadius = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // Add subtle shadow to dots
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

    final cx = size.width / 2;
    final cy = size.height / 2;
    final left = size.width * 0.2;
    final right = size.width * 0.8;
    final top = size.height * 0.2;
    final bottom = size.height * 0.8;

    final positions = _getDotPositions(
      value,
      cx: cx,
      cy: cy,
      left: left,
      right: right,
      top: top,
      bottom: bottom,
    );

    for (final pos in positions) {
      // Draw shadow first
      canvas.drawCircle(pos + const Offset(0.75, 1.5), _dotRadius, shadowPaint);
      // Draw dot
      canvas.drawCircle(pos, _dotRadius, paint);
    }
  }

  /// Returns the standard pip positions for a given dice value (1-6)
  List<Offset> _getDotPositions(
    int value, {
    required double cx,
    required double cy,
    required double left,
    required double right,
    required double top,
    required double bottom,
  }) {
    switch (value) {
      case 1:
        return [Offset(cx, cy)];
      case 2:
        return [Offset(left, top), Offset(right, bottom)];
      case 3:
        return [Offset(left, top), Offset(cx, cy), Offset(right, bottom)];
      case 4:
        return [
          Offset(left, top),
          Offset(right, top),
          Offset(left, bottom),
          Offset(right, bottom),
        ];
      case 5:
        return [
          Offset(left, top),
          Offset(right, top),
          Offset(cx, cy),
          Offset(left, bottom),
          Offset(right, bottom),
        ];
      case 6:
        return [
          Offset(left, top),
          Offset(right, top),
          Offset(left, cy),
          Offset(right, cy),
          Offset(left, bottom),
          Offset(right, bottom),
        ];
      default:
        return [Offset(cx, cy)];
    }
  }

  @override
  bool shouldRepaint(covariant _DiceDotPainter oldDelegate) =>
      oldDelegate.value != value;
}
