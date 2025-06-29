import 'package:flutter/material.dart';

class MartingaleHomePage extends StatefulWidget {
  const MartingaleHomePage({super.key});

  @override
  State<MartingaleHomePage> createState() => _MartingaleHomePageState();
}

class _MartingaleHomePageState extends State<MartingaleHomePage> {
  int _baseBet = 10;
  int _currentBet = 10;
  int _balance = 1000;
  int _totalWinnings = 0;
  int _doubledAmount = 0;
  String _lastResult = '';
  final TextEditingController _baseBetController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _baseBetController.text = _baseBet.toString();
    _balanceController.text = _balance.toString();
    _updateState();
  }

  void _updateState() {
    setState(() {
      _currentBet = _baseBet;
      _totalWinnings =
          _balance - (int.tryParse(_balanceController.text) ?? 1000);
      _lastResult = '';
      _history.clear();
    });
  }

  void _handleWin() {
    setState(() {
      _balance += _currentBet;
      _totalWinnings += _currentBet;
      _lastResult = 'Win! Bet: \$$_currentBet';
      _history.add('$_lastResult, Balance: \$$_balance');
      _currentBet = _baseBet;
      if (_currentBet > _balance) {
        _currentBet = _balance;
      }
    });
  }

  void _handleLoss() {
    setState(() {
      _doubledAmount = _currentBet * 2;
      _balance -= _currentBet;
      _totalWinnings -= _currentBet;
      _lastResult = 'Lose! Bet: \$$_currentBet';
      _history.add('$_lastResult, Balance: \$$_balance');
      if (_balance > _doubledAmount) {
        _currentBet = _doubledAmount;
      }
      //!
      else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('STOP!!!'),
            content: Text(
                'Balance is too low to you need $_doubledAmount to bet, you only have $_balance left so STOP betting!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  void _resetSystem() {
    setState(() {
      _baseBet = int.tryParse(_baseBetController.text) ?? 10;
      _balance = int.tryParse(_balanceController.text) ?? 1000;
      _currentBet = _baseBet;
      _totalWinnings = 0;
      _lastResult = '';
      _history.clear();
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Martingale System Info'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'The Martingale system is a betting strategy where you double your bet after every loss, aiming to recover all previous losses and gain a profit equal to your original bet when you eventually win.',
                ),
                SizedBox(height: 10),
                Text('How it works:'),
                Text('- Set a base bet and starting balance.'),
                Text('- If you WIN, reset your bet to the base bet.'),
                Text('- If you LOSE, double your bet for the next round.'),
                Text(
                    '- Repeat until you run out of balance or choose to stop.'),
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

  Widget inputCardSection(
    BuildContext context,
    String textTitle,
    TextEditingController controller,
    String label,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              textTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                // No-op, handled on reset
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Martingale System Simulator'),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: inputCardSection(
                        context,
                        'Base Bet',
                        _baseBetController,
                        'Enter Base Bet',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: inputCardSection(
                        context,
                        'Starting Balance',
                        _balanceController,
                        'Enter Starting Balance',
                      ),
                    ),
                  ],
                ),
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
                          'Balance: \$$_balance',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current Bet: \$$_currentBet',
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
                        const SizedBox(height: 8),
                        Text(
                          _lastResult,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            _balance > 0 && _currentBet > 0 ? _handleWin : null,
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
                        onPressed: _balance > 0 && _currentBet > 0
                            ? _handleLoss
                            : null,
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
}
