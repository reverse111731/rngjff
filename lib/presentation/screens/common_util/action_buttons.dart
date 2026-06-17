import 'package:flutter/material.dart';

/// A reusable widget for game action buttons (Clear, All In, Deal, New Round, Reset).
class GameActionButtons extends StatelessWidget {
  final bool hasResult;
  final VoidCallback onNewRound;
  final VoidCallback onClear;
  final VoidCallback onAllIn;
  final VoidCallback onDeal;
  final bool canClear;
  final bool canAllIn;
  final bool canDeal;
  final VoidCallback? onReset;

  const GameActionButtons({
    super.key,
    required this.hasResult,
    required this.onNewRound,
    required this.onClear,
    required this.onAllIn,
    required this.onDeal,
    required this.canClear,
    required this.canAllIn,
    required this.canDeal,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    Widget actionsWidget;

    if (hasResult) {
      actionsWidget = ElevatedButton.icon(
        onPressed: onNewRound,
        icon: const Icon(Icons.refresh),
        label: const Text('New Round', style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } else {
      actionsWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: canClear ? onClear : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Clear', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: canAllIn ? onAllIn : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('All In', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: canDeal ? onDeal : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Deal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    }

    if (onReset == null) return actionsWidget;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        actionsWidget,
        const SizedBox(height: 64),
        ElevatedButton(
          onPressed: () async {
            final bool? confirmed = await showDialog<bool>(
              context: context,
              builder: (dCtx) => AlertDialog(
                title: const Text('Reset Game'),
                content: const Text('Reset the game to starting capital and clear current hands?'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(dCtx).pop(false), child: const Text('Cancel')),
                  ElevatedButton(onPressed: () => Navigator.of(dCtx).pop(true), child: const Text('Reset')),
                ],
              ),
            );
            if (confirmed == true) {
              onReset!();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Game reset to starting capital')));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade800,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Reset Game', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}