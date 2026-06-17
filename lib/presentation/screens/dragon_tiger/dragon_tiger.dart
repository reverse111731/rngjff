import 'package:flutter/material.dart';
import '../common_util/playing_cards.dart';
import '../common_util/action_buttons.dart';

/// A simple Dragon Tiger game.
/// Follows standard 8-deck Dragon Tiger rules.
class DragonTigerScreen extends StatefulWidget {
  const DragonTigerScreen({super.key});

  @override
  State<DragonTigerScreen> createState() => _DragonTigerScreenState();
}

/// Dragon Tiger-specific scoring logic extension for the shared [PlayingCard] model.
extension DragonTigerScoring on PlayingCard {
  int get dragonTigerValue {
    if (rank == 1) return 1; // Ace is 1
    if (rank >= 11) {
      // J, Q, K
      if (rank == 11) return 11; // Jack
      if (rank == 12) return 12; // Queen
      if (rank == 13) return 13; // King
    }
    return rank; // 2-10 are face value
  }
}

// ---------------------------------------------------------------------------
// Bet selection
// ---------------------------------------------------------------------------

enum BetChoice { dragon, tiger, tie }

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _DragonTigerScreenState extends State<DragonTigerScreen>
    with SingleTickerProviderStateMixin {
  final Shoe _shoe = Shoe(deckCount: 8); // Standard 8 decks
  int _startingBalance = 1000;

  // Chips
  int _balance = 1000;
  int _currentBet = 0;
  BetChoice? _betChoice;

  // Hands
  PlayingCard? _dragonCard;
  PlayingCard? _tigerCard;

  // Round result
  String? _resultMessage;
  bool _roundInProgress = false;

  // Chip denominations
  static const List<int> _chipValues = [10, 25, 50, 100, 500, 1000];

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showStartingCapitalModal();
    });
  }

  Future<void> _showStartingCapitalModal() async {
    final controller = TextEditingController();
    final presets = <int>[500, 1000, 2000, 5000, 10000, 20000];

    int selectedPreset = _startingBalance;
    String? customError;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: const Text('Select Starting Capital'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: presets.map((amount) {
                        return ChoiceChip(
                          label: Text('$amount'),
                          selected: selectedPreset == amount,
                          onSelected: (_) {
                            setDialogState(() {
                              selectedPreset = amount;
                              controller.clear();
                              customError = null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Custom amount',
                        errorText: customError,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) {
                          setDialogState(() {
                            selectedPreset = -1;
                            customError = null;
                          });
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      final customText = controller.text.trim();
                      int selectedAmount;

                      if (customText.isNotEmpty) {
                        final parsed = int.tryParse(customText);
                        if (parsed == null || parsed <= 0) {
                          setDialogState(() {
                            customError = 'Please enter a valid amount';
                          });
                          return;
                        }
                        selectedAmount = parsed;
                      } else {
                        selectedAmount = selectedPreset;
                      }

                      setState(() {
                        _startingBalance = selectedAmount;
                        _balance = selectedAmount;
                        _currentBet = 0;
                        _betChoice = null;
                        _dragonCard = null;
                        _tigerCard = null;
                        _resultMessage = null;
                        _roundInProgress = false;
                      });

                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Start Game'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Game logic
  // ---------------------------------------------------------------------------

  void _deal() {
    if (_currentBet == 0 || _betChoice == null) return;

    setState(() {
      _roundInProgress = true;
      _resultMessage = null;
      _dragonCard = _shoe.draw();
      _tigerCard = _shoe.draw();
    });

    _resolve();
  }

  void _resolve() {
    if (_dragonCard == null || _tigerCard == null) return;

    final dragonValue = _dragonCard!.dragonTigerValue;
    final tigerValue = _tigerCard!.dragonTigerValue;

    String winner;
    int payout = 0;

    if (dragonValue > tigerValue) {
      winner = 'Dragon wins!';
      if (_betChoice == BetChoice.dragon) payout = _currentBet * 2; // 1:1 payout
    } else if (tigerValue > dragonValue) {
      winner = 'Tiger wins!';
      if (_betChoice == BetChoice.tiger) payout = _currentBet * 2; // 1:1 payout
    } else {
      winner = 'Tie!';
      if (_betChoice == BetChoice.tie) {
        payout = _currentBet * 12; // 11:1 payout
      } else {
        // If Dragon/Tiger bet and it's a tie, usually Dragon/Tiger bets lose.
        payout = 0;
      }
    }

    setState(() {
      _balance += payout;
      _resultMessage =
          '$winner \n (Dragon ${dragonValue} — Tiger ${tigerValue})';
      _roundInProgress = false;
    });
  }

  void _newRound() {
    setState(() {
      _dragonCard = null;
      _tigerCard = null;
      _currentBet = 0;
      _betChoice = null;
      _resultMessage = null;
    });
  }

  void _resetGame() {
    setState(() {
      _balance = _startingBalance;
      _dragonCard = null;
      _tigerCard = null;
      _currentBet = 0;
      _betChoice = null;
      _resultMessage = null;
      _roundInProgress = false;
    });
  }

  void _placeBet(int amount) {
    if (_roundInProgress) return;
    if (_balance < amount) return;
    setState(() {
      _balance -= amount;
      _currentBet += amount;
    });
  }

  void _clearBet() {
    if (_roundInProgress) return;
    setState(() {
      _balance += _currentBet;
      _currentBet = 0;
      _betChoice = null;
    });
  }

  void _allIn() {
    if (_roundInProgress) return;
    if (_balance <= 0) return;
    setState(() {
      _currentBet += _balance;
      _balance = 0;
    });
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0B6623), // Same as Baccarat for consistency
        appBar: AppBar(
          title: const Text(
            'Dragon Tiger',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0A4F1C),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              tooltip: 'Rules',
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                _showRulesDialog(); // Simple dialog for rules
              },
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      _buildBalanceBar(),
                      const SizedBox(height: 24),
                      _buildHandSection('Dragon', _dragonCard),
                      const SizedBox(height: 24),
                      _buildHandSection('Tiger', _tigerCard),
                      const SizedBox(height: 24),
                      if (_resultMessage != null) _buildResultBanner(),
                      const SizedBox(height: 24),
                      _buildBetChoiceRow(),
                      const SizedBox(height: 24),
                      _buildChipRow(),
                      const SizedBox(height: 36),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Balance: $_balance',
            style: const TextStyle(
              color: Colors.amberAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Bet: $_currentBet',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandSection(String label, PlayingCard? card) {
    final value = card == null ? '-' : card.dragonTigerValue.toString();
    return Column(
      children: [
        Text(
          '$label ($value)',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        card == null ? _buildEmptySlot() : _buildCard(card),
      ],
    );
  }

  Widget _buildCard(PlayingCard card) {
    return Container(
      width: 72,
      height: 104,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.rankLabel,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: card.suitColor,
            ),
          ),
          Text(
            card.suitSymbol,
            style: TextStyle(fontSize: 24, color: card.suitColor),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      width: 72,
      height: 104,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
    );
  }

  Widget _buildResultBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _resultMessage!,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.amberAccent,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBetChoiceRow() {
    if (_roundInProgress || _dragonCard != null) return const SizedBox();

    const orderedChoices = [
      BetChoice.dragon,
      BetChoice.tie,
      BetChoice.tiger,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: orderedChoices.map((choice) {
        final label = choice == BetChoice.dragon
            ? 'DRAGON'
            : (choice == BetChoice.tiger ? 'TIGER' : 'TIE');
        final isSelected = _betChoice == choice;
        return GestureDetector(
          onTap: () => setState(() => _betChoice = choice),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amberAccent : Colors.white12,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.amber : Colors.white38,
                width: 2,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChipRow() {
    if (_roundInProgress || _dragonCard != null) return const SizedBox();

    final topRowChips = _chipValues.where((v) => v <= 50).toList();
    final bottomRowChips = _chipValues.where((v) => v >= 100).toList();

    return Column(
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.center,
          children: topRowChips.map(_buildChip).toList(),
        ),
        if (bottomRowChips.isNotEmpty) const SizedBox(height: 8),
        if (bottomRowChips.isNotEmpty)
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: bottomRowChips.map(_buildChip).toList(),
          ),
      ],
    );
  }

  Widget _buildChip(int val) {
    return GestureDetector(
      onTap: () => _placeBet(val),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: _chipGradient(val),
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
          '$val',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  List<Color> _chipGradient(int val) {
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

  Widget _buildActionButtons() {
    return GameActionButtons(
      hasResult: _resultMessage != null,
      onNewRound: _newRound,
      onClear: _clearBet,
      onAllIn: _allIn,
      onDeal: _deal,
      canClear: _currentBet > 0,
      canAllIn: _balance > 0,
      canDeal: _currentBet > 0 && _betChoice != null,
      onReset: _resetGame,
    );
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Dragon Tiger Rules'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Dragon Tiger is a simple card game where two cards are dealt: one to the "Dragon" position and one to the "Tiger" position.',
                ),
                SizedBox(height: 8),
                Text('Objective:'),
                Text(
                    '- Bet on which position will receive the higher card, or if it will be a Tie.'),
                SizedBox(height: 8),
                Text('Card Values:'),
                Text('- King (K) is the highest (13 points).'),
                Text('- Queen (Q) is 12 points.'),
                Text('- Jack (J) is 11 points.'),
                Text('- 10 through 2 are face value.'),
                Text('- Ace (A) is the lowest (1 point).'),
                Text('- Suits do not matter.'),
                SizedBox(height: 8),
                Text('Payouts:'),
                Text('- Dragon: 1 to 1'),
                Text('- Tiger: 1 to 1'),
                Text('- Tie: 11 to 1'),
                Text('- If a Tie occurs, Dragon and Tiger bets lose.'),
                SizedBox(height: 8),
                Text(
                    'Disclaimer: Dragon Tiger is a game of chance and all bets involve risk.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got It'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}