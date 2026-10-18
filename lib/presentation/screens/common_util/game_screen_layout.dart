import 'package:flutter/material.dart';

class GameScreenScaffold extends StatelessWidget {
  const GameScreenScaffold({
    required this.title,
    required this.color1,
    required this.color2,
    required this.selectedDiceCount,
    required this.isRolling,
    required this.onDiceCountChanged,
    required this.child,
    super.key,
  });

  final String title;
  final Color color1;
  final Color color2;
  final int selectedDiceCount;
  final bool isRolling;
  final ValueChanged<int> onDiceCountChanged;
  final Widget child;

  void _showDiceCountSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF202A44),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Number of dice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RadioGroup<int>(
                groupValue: selectedDiceCount,
                onChanged: (value) {
                  if (value == null) return;
                  onDiceCountChanged(value);
                  Navigator.pop(sheetContext);
                },
                child: Column(
                  children: [
                    for (final option in [
                      (1, '1 Die'),
                      (2, '2 Dice'),
                      (3, '3 Dice'),
                    ])
                      RadioListTile<int>(
                        title: Text(
                          option.$2,
                          style: const TextStyle(color: Colors.white),
                        ),
                        value: option.$1,
                        fillColor: const WidgetStatePropertyAll(Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: color1,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back to selection',
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.casino_outlined),
              label: Text(
                selectedDiceCount == 1 ? '1 die' : '$selectedDiceCount dice',
              ),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed:
                  isRolling ? null : () => _showDiceCountSelector(context),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color1, color2],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight > 32
                      ? constraints.maxHeight - 32
                      : 0,
                ),
                child: IntrinsicHeight(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameRollLayout extends StatelessWidget {
  const GameRollLayout({
    required this.header,
    required this.resultSummary,
    required this.resultRevision,
    required this.dice,
    required this.isRolling,
    required this.rollButtonLabel,
    required this.onRoll,
    this.secondarySummary,
    super.key,
  });

  final Widget header;
  final String resultSummary;
  final int resultRevision;
  final String? secondarySummary;
  final Widget dice;
  final bool isRolling;
  final String rollButtonLabel;
  final VoidCallback onRoll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        const SizedBox(height: 24),
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            isRolling ? 'Rolling...' : resultSummary,
            key: ValueKey<int>(resultRevision),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        if (secondarySummary != null) ...[
          const SizedBox(height: 8),
          Text(
            secondarySummary!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white60,
              letterSpacing: 0.5,
            ),
          ),
        ],
        const SizedBox(height: 16),
        dice,
        const SizedBox(height: 20),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.14),
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: isRolling ? null : onRoll,
            child: Text(isRolling ? 'Rolling...' : rollButtonLabel),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
