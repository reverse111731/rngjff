import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Alignment constants for the gradient background
const _startAlignment = Alignment.topLeft;
const _endAlignment = Alignment.bottomRight;

/// Six possible colors in the Color Game
enum GameColor {
  yellow(
    name: 'Yellow',
    color: Color(0xFFFFD600),
    textColor: Color(0xFF212121),
    borderColor: Color(0xFFC79100),
  ),
  white(
    name: 'White',
    color: Color(0xFFFFFFFF),
    textColor: Color(0xFF212121),
    borderColor: Color(0xFFB0BEC5),
  ),
  pink(
    name: 'Pink',
    color: Color(0xFFE91E63),
    textColor: Colors.white,
    borderColor: Color(0xFFC2185B),
  ),
  blue(
    name: 'Blue',
    color: Color(0xFF1E88E5),
    textColor: Colors.white,
    borderColor: Color(0xFF1565C0),
  ),
  red(
    name: 'Red',
    color: Color(0xFFE53935),
    textColor: Colors.white,
    borderColor: Color(0xFFB71C1C),
  ),
  green(
    name: 'Green',
    color: Color(0xFF43A047),
    textColor: Colors.white,
    borderColor: Color(0xFF2E7D32),
  );

  const GameColor({
    required this.name,
    required this.color,
    required this.textColor,
    required this.borderColor,
  });

  final String name;
  final Color color;
  final Color textColor;
  final Color borderColor;
}

/// ColorGameScreen widget providing a gradient background and game body
class ColorGameScreen extends StatelessWidget {
  const ColorGameScreen({
    this.color1 = const Color(0xFF1A1A2E),
    this.color2 = const Color(0xFF16213E),
    super.key,
  });

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
          child: const Center(child: ColorRoller()),
        ),
      ),
    );
  }
}

/// Convenient alias for ColorGameScreen supporting positional or default colors
class ColorGame extends ColorGameScreen {
  const ColorGame([
    Color color1 = const Color(0xFF1A1A2E),
    Color color2 = const Color(0xFF16213E),
    Key? key,
  ]) : super(color1: color1, color2: color2, key: key);
}

/// ColorRoller StatefulWidget managing the state of the color dice and rolls
class ColorRoller extends StatefulWidget {
  const ColorRoller({super.key});

  @override
  State<ColorRoller> createState() => _ColorRollerState();
}

class _ColorRollerState extends State<ColorRoller> {
  final Random _randomizer = Random();
  Timer? _rollTimer;
  bool _isRolling = false;

  // Selected number of dice (1, 2, or 3)
  int _selectedDiceCount = 3;

  // Current rolled colors for each die
  List<GameColor> _currentRolls = [
    GameColor.yellow,
    GameColor.white,
    GameColor.pink,
  ];

  @override
  void dispose() {
    _rollTimer?.cancel();
    super.dispose();
  }

  // Generate random colors for the active dice
  List<GameColor> _generateRandomRolls(int count) {
    return List.generate(
      count,
      (_) => GameColor.values[_randomizer.nextInt(GameColor.values.length)],
    );
  }

  // Rolls all selected dice with a rapid shuffling animation
  void _rollAllDice() {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
    });

    int ticks = 0;
    const maxTicks = 8;
    _rollTimer?.cancel();

    _rollTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      ticks++;
      if (ticks >= maxTicks) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _currentRolls = _generateRandomRolls(_selectedDiceCount);
            _isRolling = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _currentRolls = _generateRandomRolls(_selectedDiceCount);
          });
        }
      }
    });
  }

  // Summary title describing the roll result
  String _getResultSummary() {
    if (_currentRolls.isEmpty) return '';
    if (_currentRolls.length == 1) {
      return _currentRolls.first.name;
    }

    // Check for matching combinations (e.g. Double or Triple)
    final colorCounts = <GameColor, int>{};
    for (final c in _currentRolls) {
      colorCounts[c] = (colorCounts[c] ?? 0) + 1;
    }

    for (final entry in colorCounts.entries) {
      if (entry.value == 3) {
        return 'Triple ${entry.key.name}!';
      }
      if (entry.value == 2 && _currentRolls.length == 3) {
        return 'Double ${entry.key.name}!';
      }
      if (entry.value == 2 && _currentRolls.length == 2) {
        return 'Double ${entry.key.name}!';
      }
    }

    return _currentRolls.map((c) => c.name).join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Title banner
        const Text(
          'COLOR GAME',
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
              _currentRolls = List.generate(
                value,
                (index) => [
                  GameColor.yellow,
                  GameColor.white,
                  GameColor.pink,
                ][index],
              );
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

        // Result summary text (e.g. "Yellow • White • Pink" or "Triple Red!")
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

        // Display the color dice
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _currentRolls.map((gameColor) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: _ColorDieWidget(gameColor: gameColor),
            );
          }).toList(),
        ),

        // Button to roll the colors
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: _rollAllDice,
          child: Text(_isRolling ? 'Rolling...' : 'Roll Colors'),
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

/// A 3D-styled dice block displaying a GameColor
class _ColorDieWidget extends StatelessWidget {
  const _ColorDieWidget({required this.gameColor});

  final GameColor gameColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      decoration: BoxDecoration(
        color: gameColor.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gameColor.borderColor.withValues(alpha: 0.8),
          width: 3.0,
        ),
        boxShadow: [
          // Bottom drop shadow for 3D depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
          // Inner/outer ambient glow
          BoxShadow(
            color: gameColor.color.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Light highlight reflection on top
            Colors.white.withValues(alpha: 0.28),
            gameColor.color,
            // Darker tone at the bottom corner for cube bevel
            Colors.black.withValues(alpha: 0.15),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            gameColor.name.toUpperCase(),
            style: TextStyle(
              color: gameColor.textColor,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
