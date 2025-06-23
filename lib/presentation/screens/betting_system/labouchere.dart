import 'package:flutter/material.dart';

class LabouchereHomePage extends StatefulWidget {
  const LabouchereHomePage({super.key});

  @override
  State<LabouchereHomePage> createState() => _LabouchereHomePageState();
}

class _LabouchereHomePageState extends State<LabouchereHomePage> {
  // The core list representing the Labouchere sequence
  List<int> _sequence = [];
  // The user's target amount to win
  int _targetAmount = 100;
  // Current bet amount
  int _currentBet = 0;
  // Total amount won/lost
  int _totalWinnings = 0;
  // user input for sequence
  final int _sequenceInput = 10;
  // Input controller for target amount
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _sequenceController = TextEditingController();
  // History of bets and results
  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _targetController.text = _targetAmount.toString();
    _initializeSequence();
  }

  // Initializes the Labouchere sequence based on the target amount
  void _initializeSequence() {
    // A simple way to create a sequence for a target amount, e.g.,
    // if target is 100, sequence could be [10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
    // or [5, 10, 15, 20, 25, 25] if breaking it down differently.
    // For simplicity, let's divide the target into 10 equal parts.
    // This is a common strategy but can be customized.
    if (_targetAmount > 0) {
      final int baseUnit = (_targetAmount / _sequenceInput).round();
      _sequence = List<int>.generate(_sequenceInput, (_) => baseUnit);
      if (_sequence.isEmpty) {
        // Edge case for very small target amounts
        _sequence = [_targetAmount];
      }
      // Ensure the sum of the sequence equals the target, adjust last element if needed
      int currentSum = _sequence.reduce((a, b) => a + b);
      if (currentSum != _targetAmount) {
        _sequence[_sequence.length - 1] += (_targetAmount - currentSum);
      }
    } else {
      _sequence = [0]; // Or handle as an error
    }
    _history.clear();
    _calculateNextBet();
  }

  // Calculates the next bet based on the current sequence
  void _calculateNextBet() {
    setState(() {
      if (_sequence.isEmpty) {
        _currentBet = 0;
        _history.add("Sequence empty. Target achieved or system reset needed.");
        return;
      }
      if (_sequence.length == 1) {
        _currentBet = _sequence[0];
      } else {
        _currentBet = _sequence.first + _sequence.last;
      }
      _history
          .add("Sequence: ${_sequence.join(', ')} \n Next Bet: $_currentBet");
    });
  }

  // Handles a win
  void _handleWin() {
    setState(() {
      if (_sequence.isEmpty) {
        _history.add("Cannot win, sequence already empty.");
        return;
      }
      // Remove first and last elements on a win
      if (_sequence.length > 1) {
        _sequence.removeAt(0);
        _sequence.removeLast();
      } else {
        _sequence.clear(); // If only one element, sequence becomes empty
      }
      _totalWinnings += _currentBet;
      _history.add("WIN! Bet: $_currentBet, Winnings: $_totalWinnings");
      _calculateNextBet();
    });
  }

  // Handles a loss
  void _handleLoss() {
    setState(() {
      if (_sequence.isEmpty) {
        _history.add("Cannot lose, sequence already empty.");
        return;
      }
      // Add the lost bet to the end of the sequence
      _sequence.add(_currentBet);
      _totalWinnings -= _currentBet;
      _history.add("LOSS! Bet: $_currentBet, Winnings: $_totalWinnings");
      _calculateNextBet();
    });
  }

  // Resets the system
  void _resetSystem() {
    setState(() {
      _targetAmount = int.tryParse(_targetController.text) ?? 100;
      _totalWinnings = 0;
      _currentBet = 0;
      _initializeSequence();
      _history.add("System reset. New Target: $_targetAmount");
    });
  }

  // Shows an information dialog
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Labouchere System Info'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'The Labouchere system (also known as the Cancellation System or Split Martingale) is a roulette betting strategy that involves crossing out numbers from a sequence after wins and adding numbers after losses.',
                ),
                SizedBox(height: 10),
                Text('How it works:'),
                Text('- Define a target amount you wish to win.'),
                Text(
                    '- Create a sequence of numbers that sum up to your target amount.'),
                Text(
                    '- Your bet is the sum of the first and last numbers in the sequence.'),
                Text('- If you WIN, cross out the first and last numbers.'),
                Text(
                    '- If you LOSE, add the bet amount to the end of the sequence.'),
                Text(
                    '- The system is completed when all numbers are crossed out, ideally achieving your target win.'),
                SizedBox(height: 10),
                Text(
                    'Disclaimer: Betting systems do not guarantee profits and involve risk.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labouchere System Simulator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Added SingleChildScrollView here
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Target Amount Input
                Row(
                  children: [
                    Expanded(
                      child: inputCardSection(context),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: inputCardSection(context),
                    )
                  ],
                ),

                // Current State Display
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current State:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sequence: ${_sequence.isEmpty ? 'Empty' : _sequence.join(', ')}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Next Bet: $_currentBet',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Winnings/Losses: $_totalWinnings',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: _totalWinnings >= 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _handleWin,
                        icon: const Icon(Icons.check),
                        label: const Text('WIN'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          elevation: 3,
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _resetSystem,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 3,
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _handleLoss,
                        icon: const Icon(Icons.close),
                        label: const Text('LOSE'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          elevation: 3,
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // History Log
                SizedBox(
                  height: 300,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'History Log:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _history.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                      _history[_history.length - 1 - index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputCardSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Target Winnings',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Target Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                // Update target amount as user types
                _targetAmount = int.tryParse(value) ?? 0;
              },
            ),
          ],
        ),
      ),
    );
  }
}
