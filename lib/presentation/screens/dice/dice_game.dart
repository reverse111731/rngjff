import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../common_util/game_screen_layout.dart';

/// GradientContainer widget that provides a dark gradient background
/// for the dice game (similar to the color game's dark theme).
class GradientContainer extends StatelessWidget {
  const GradientContainer(this.color1, this.color2, {super.key});

  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return DiceRoller(color1: color1, color2: color2);
  }
}

/// DiceRoller StatefulWidget managing the state of the dice and their rolls.
class DiceRoller extends StatefulWidget {
  const DiceRoller({
    required this.color1,
    required this.color2,
    super.key,
  });

  final Color color1;
  final Color color2;

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
  int _resultRevision = 0;

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
  int get _totalValue => _currentDiceRolls.fold(0, (sum, roll) => sum + roll);

  /// Generate random roll values for a given dice count
  List<int> _generateRandomRolls(int count) {
    return List.generate(count, (_) => _randomizer.nextInt(6) + 1);
  }

  /// Rolls all dice with a rapid shuffling animation (matching color game style)
  void _rollAllDice() {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
      _resultRevision++;
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
            _resultRevision++;
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
    return GameScreenScaffold(
      title: 'Dice Game',
      color1: widget.color1,
      color2: widget.color2,
      selectedDiceCount: _selectedDiceCount,
      isRolling: _isRolling,
      onDiceCountChanged: (count) {
        setState(() {
          _selectedDiceCount = count;
          _currentDiceRolls = List.generate(count, (_) => 1);
          _resultRevision++;
        });
      },
      child: GameRollLayout(
        header: const Text(
          'Choose 1–3 dice to roll',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        resultSummary: _getResultSummary(),
        resultRevision: _resultRevision,
        secondarySummary: 'Total: $_totalValue',
        dice: ScaleTransition(
          scale: _bounceAnimation,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: _currentDiceRolls
                .map(
                  (value) => _DiceWidget(
                    value: value,
                    isRolling: _isRolling,
                  ),
                )
                .toList(),
          ),
        ),
        isRolling: _isRolling,
        rollButtonLabel: 'Roll Dice',
        onRoll: _rollAllDice,
      ),
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
