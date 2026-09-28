import 'package:flutter/material.dart';

class GameChip extends StatelessWidget {
  final int value;
  final ValueChanged<int> onTap;

  const GameChip({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: _chipGradient(value),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 4,
              offset: Offset(1, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  static List<Color> _chipGradient(int val) {
    switch (val) {
      case 10:
        return [Colors.blue.shade700, Colors.blue.shade400];
      case 25:
        return [Colors.green.shade700, Colors.green.shade400];
      case 50:
        return [Colors.red.shade700, Colors.red.shade400];
      case 100:
        return [Colors.purple.shade700, Colors.purple.shade400];
      case 500:
        return [Colors.orange.shade700, Colors.orange.shade400];
      case 1000:
        return [Colors.teal.shade700, Colors.teal.shade400];
      default:
        return [Colors.grey.shade700, Colors.grey.shade400];
    }
  }
}

class GameChipRow extends StatelessWidget {
  final List<int> chipValues;
  final bool isVisible;
  final ValueChanged<int> onChipTap;

  const GameChipRow({
    super.key,
    required this.chipValues,
    required this.isVisible,
    required this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox();

    final topRowChips = chipValues.where((v) => v <= 50).toList();
    final bottomRowChips = chipValues.where((v) => v >= 100).toList();

    return Column(
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.center,
          children: topRowChips
              .map((val) => GameChip(value: val, onTap: onChipTap))
              .toList(),
        ),
        if (bottomRowChips.isNotEmpty) const SizedBox(height: 8),
        if (bottomRowChips.isNotEmpty)
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: bottomRowChips
                .map((val) => GameChip(value: val, onTap: onChipTap))
                .toList(),
          ),
      ],
    );
  }
}
