import 'dart:math';
import 'package:flutter/material.dart';
import 'baccarat_rules.dart';

/// A simple Baccarat game with Player, Banker, and Tie betting.
/// Follows standard 8-deck baccarat third-card rules.
class BaccaratScreen extends StatefulWidget {
  const BaccaratScreen({super.key});

  @override
  State<BaccaratScreen> createState() => _BaccaratScreenState();
}

// ---------------------------------------------------------------------------
// Card model
// ---------------------------------------------------------------------------

enum Suit { spades, hearts, diamonds, clubs }

class PlayingCard {
  final int rank; // 1=Ace, 2-10, 11=J, 12=Q, 13=K
  final Suit suit;

  const PlayingCard(this.rank, this.suit);

  int get baccaratValue {
    if (rank >= 10) return 0;
    return rank;
  }

  String get rankLabel {
    switch (rank) {
      case 1:
        return 'A';
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      default:
        return rank.toString();
    }
  }

  String get suitSymbol {
    switch (suit) {
      case Suit.spades:
        return '♠';
      case Suit.hearts:
        return '♥';
      case Suit.diamonds:
        return '♦';
      case Suit.clubs:
        return '♣';
    }
  }

  Color get suitColor {
    switch (suit) {
      case Suit.hearts:
      case Suit.diamonds:
        return Colors.red;
      case Suit.spades:
      case Suit.clubs:
        return Colors.black;
    }
  }
}

// ---------------------------------------------------------------------------
// Shoe (8-deck)
// ---------------------------------------------------------------------------

class Shoe {
  final Random _rng = Random();
  final List<PlayingCard> _cards = [];

  Shoe() {
    _rebuild();
  }

  void _rebuild() {
    _cards.clear();
    for (int d = 0; d < 8; d++) {
      for (final suit in Suit.values) {
        for (int r = 1; r <= 13; r++) {
          _cards.add(PlayingCard(r, suit));
        }
      }
    }
    _cards.shuffle(_rng);
  }

  PlayingCard draw() {
    if (_cards.length < 6) _rebuild();
    return _cards.removeLast();
  }
}

// ---------------------------------------------------------------------------
// Bet selection
// ---------------------------------------------------------------------------

enum BetChoice { player, banker, tie }

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _BaccaratScreenState extends State<BaccaratScreen>
    with SingleTickerProviderStateMixin {
  final Shoe _shoe = Shoe();
  int _startingBalance = 1000;

  // Chips
  int _balance = 1000;
  int _currentBet = 0;
  BetChoice? _betChoice;

  // Hands
  List<PlayingCard> _playerHand = [];
  List<PlayingCard> _bankerHand = [];

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
                        _playerHand = [];
                        _bankerHand = [];
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

  int _handTotal(List<PlayingCard> hand) {
    int sum = 0;
    for (final c in hand) {
      sum += c.baccaratValue;
    }
    return sum % 10;
  }

  // ---------------------------------------------------------------------------
  // Game logic — standard baccarat third-card rules
  // ---------------------------------------------------------------------------

  void _deal() {
    if (_currentBet == 0 || _betChoice == null) return;

    setState(() {
      _roundInProgress = true;
      _resultMessage = null;
      _playerHand = [_shoe.draw(), _shoe.draw()];
      _bankerHand = [_shoe.draw(), _shoe.draw()];
    });

    // Naturals check
    final playerTotal = _handTotal(_playerHand);
    final bankerTotal = _handTotal(_bankerHand);

    if (playerTotal >= 8 || bankerTotal >= 8) {
      _resolve();
      return;
    }

    // Player third-card rule
    PlayingCard? playerThird;
    if (playerTotal <= 5) {
      playerThird = _shoe.draw();
      setState(() => _playerHand.add(playerThird!));
    }

    // Banker third-card rule
    if (playerThird == null) {
      // Player stood — banker draws on 0-5
      if (_handTotal(_bankerHand) <= 5) {
        setState(() => _bankerHand.add(_shoe.draw()));
      }
    } else {
      final pv = playerThird.baccaratValue;
      final bt = _handTotal(_bankerHand);
      bool bankerDraws = false;

      if (bt <= 2) {
        bankerDraws = true;
      } else if (bt == 3 && pv != 8) {
        bankerDraws = true;
      } else if (bt == 4 && pv >= 2 && pv <= 7) {
        bankerDraws = true;
      } else if (bt == 5 && pv >= 4 && pv <= 7) {
        bankerDraws = true;
      } else if (bt == 6 && (pv == 6 || pv == 7)) {
        bankerDraws = true;
      }

      if (bankerDraws) {
        setState(() => _bankerHand.add(_shoe.draw()));
      }
    }

    _resolve();
  }

  void _resolve() {
    final pt = _handTotal(_playerHand);
    final bt = _handTotal(_bankerHand);

    String winner;
    int payout = 0;

    if (pt > bt) {
      winner = 'Player wins!';
      if (_betChoice == BetChoice.player) payout = _currentBet * 2;
    } else if (bt > pt) {
      winner = 'Banker wins!';
      if (_betChoice == BetChoice.banker) {
        payout = _currentBet * 2;
      }
    } else {
      winner = 'Tie!';
      if (_betChoice == BetChoice.tie) {
        payout = _currentBet * 9; // 8:1 payout
      } else {
        // Push on tie for player/banker bets
        payout = _currentBet;
      }
    }

    setState(() {
      _balance += payout;
      _resultMessage = '$winner \n (Player $pt — Banker $bt)';
      _roundInProgress = false;
    });
  }

  void _newRound() {
    setState(() {
      _playerHand = [];
      _bankerHand = [];
      _currentBet = 0;
      _betChoice = null;
      _resultMessage = null;
    });
  }

  void _resetGame() {
    setState(() {
      _balance = _startingBalance;
      _playerHand = [];
      _bankerHand = [];
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
    return Scaffold(
      backgroundColor: const Color(0xFF0B6623),
      appBar: AppBar(
        title: const Text(
          'Baccarat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0A4F1C),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Rules',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BaccaratRulesScreen(),
                ),
              );
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
                    _buildHandSection('Banker', _bankerHand),
                    const SizedBox(height: 24),
                    _buildHandSection('Player', _playerHand),
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

  Widget _buildHandSection(String label, List<PlayingCard> hand) {
    final total = hand.isEmpty ? '-' : _handTotal(hand).toString();
    return Column(
      children: [
        Text(
          '$label  ($total)',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: hand.isEmpty
              ? [_buildEmptySlot(), const SizedBox(width: 8), _buildEmptySlot()]
              : hand
                  .map((c) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildCard(c),
                      ))
                  .toList(),
        ),
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
    if (_roundInProgress || _playerHand.isNotEmpty) return const SizedBox();

    const orderedChoices = [
      BetChoice.player,
      BetChoice.tie,
      BetChoice.banker,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: orderedChoices.map((choice) {
        final label = choice == BetChoice.player
            ? 'PLAYER'
            : (choice == BetChoice.banker ? 'BANKER' : 'TIE');
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
    if (_roundInProgress || _playerHand.isNotEmpty) return const SizedBox();

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
    if (_resultMessage != null) {
      return ElevatedButton.icon(
        onPressed: _newRound,
        icon: const Icon(Icons.refresh),
        label: const Text('New Round', style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _currentBet > 0 ? _clearBet : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade800,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Clear', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _balance > 0 ? _allIn : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('All In', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: (_currentBet > 0 && _betChoice != null) ? _deal : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amberAccent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Deal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
