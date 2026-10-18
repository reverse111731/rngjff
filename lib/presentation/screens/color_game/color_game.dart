import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../common_util/game_screen_layout.dart';

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
class ColorGameScreen extends StatefulWidget {
  const ColorGameScreen({
    this.color1 = const Color(0xFF1A1A2E),
    this.color2 = const Color(0xFF16213E),
    super.key,
  });

  final Color color1;
  final Color color2;

  @override
  State<ColorGameScreen> createState() => _ColorGameScreenState();
}

class _ColorGameScreenState extends State<ColorGameScreen> {
  int _selectedDiceCount = 3;
  bool _isRolling = false;

  @override
  Widget build(BuildContext context) {
    return GameScreenScaffold(
      title: 'Color Game',
      color1: widget.color1,
      color2: widget.color2,
      selectedDiceCount: _selectedDiceCount,
      isRolling: _isRolling,
      onDiceCountChanged: (count) {
        setState(() => _selectedDiceCount = count);
      },
      child: ColorRoller(
        selectedDiceCount: _selectedDiceCount,
        onRollingChanged: (isRolling) {
          setState(() => _isRolling = isRolling);
        },
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
  const ColorRoller({
    required this.selectedDiceCount,
    required this.onRollingChanged,
    super.key,
  });

  final int selectedDiceCount;
  final ValueChanged<bool> onRollingChanged;

  @override
  State<ColorRoller> createState() => _ColorRollerState();
}

class _ColorRollerState extends State<ColorRoller> {
  final Random _randomizer = Random();
  Timer? _rollTimer;
  bool _isRolling = false;

  int _resultRevision = 0;

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

  @override
  void didUpdateWidget(covariant ColorRoller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDiceCount != widget.selectedDiceCount) {
      _currentRolls = List.generate(
        widget.selectedDiceCount,
        (index) => [
          GameColor.yellow,
          GameColor.white,
          GameColor.pink,
        ][index],
      );
      _resultRevision++;
    }
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
      _resultRevision++;
    });
    widget.onRollingChanged(true);

    int ticks = 0;
    const maxTicks = 8;
    _rollTimer?.cancel();

    _rollTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      ticks++;
      if (ticks >= maxTicks) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _currentRolls = _generateRandomRolls(widget.selectedDiceCount);
            _isRolling = false;
            _resultRevision++;
          });
          widget.onRollingChanged(false);
        }
      } else {
        if (mounted) {
          setState(() {
            _currentRolls = _generateRandomRolls(widget.selectedDiceCount);
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
    return GameRollLayout(
      header: const _ColorOptionsGuide(),
      resultSummary: _getResultSummary(),
      resultRevision: _resultRevision,
      dice: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: _currentRolls
            .map((gameColor) => _ColorDieWidget(gameColor: gameColor))
            .toList(),
      ),
      isRolling: _isRolling,
      rollButtonLabel: 'Roll Colors',
      onRoll: _rollAllDice,
    );
  }
}

class _ColorOptionsGuide extends StatelessWidget {
  const _ColorOptionsGuide();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'COLOR OPTIONS',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        for (var row = 0; row < 2; row++)
          Padding(
            padding: EdgeInsets.only(top: row == 0 ? 0 : 8),
            child: Row(
              children: GameColor.values
                  .skip(row * 3)
                  .take(3)
                  .map(
                    (gameColor) => Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: gameColor.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: gameColor.borderColor,
                                width: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              gameColor.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
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
      width: 142.5,
      height: 142.5,
      decoration: BoxDecoration(
        color: gameColor.color,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: gameColor.borderColor.withValues(alpha: 0.8),
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
            color: gameColor.color.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 3),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            gameColor.name.toUpperCase(),
            style: TextStyle(
              color: gameColor.textColor,
              fontSize: 19.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}
