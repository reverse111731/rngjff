import 'package:flutter/material.dart';

class MartingaleListPage extends StatefulWidget {
  const MartingaleListPage({super.key});

  @override
  State<MartingaleListPage> createState() => _MartingaleListPageState();
}

class _MartingaleListPageState extends State<MartingaleListPage> {
  final List<int> _martingaleSequence = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final TextEditingController baseBetController = TextEditingController();
  int baseBet = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    baseBetController.text = baseBet.toString();
    _generateMoreMartingale();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void compute() {
    if (baseBetController.text.isNotEmpty) {
      final String inputBet = baseBetController.text.trim();
      final int parsedBet = int.tryParse(inputBet)!;

      setState(() {
        baseBet = parsedBet;
        _martingaleSequence.clear();
        _generateMoreMartingale();
        FocusScope.of(context).unfocus();
        baseBetController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enter a number'),
          content: const Text('You have not entered a base bet to compute Martingale.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _martingaleSequence.length < 10) {
      _generateMoreMartingale();
    }
  }

  void _generateMoreMartingale() {
    if (_martingaleSequence.length >= 10) return;

    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      int countToAdd = 10;
      for (int i = 0; i < countToAdd; i++) {
        if (_martingaleSequence.length >= 10) break;
        if (_martingaleSequence.isEmpty) {
          _martingaleSequence.add(baseBet);
        } else {
          _martingaleSequence.add(_martingaleSequence.last * 2);
        }
      }
      setState(() {
        _isLoadingMore = false;
      });
    });
  }


  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Martingale System Info'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'The Martingale system is a betting strategy where you double your bet after every loss, aiming to recover all previous losses and gain a profit equal to your original bet when you eventually win.',
                ),
                SizedBox(height: 10),
                Text('How it works:'),
                Text('- Set a base bet amount.'),
                Text('- Each step doubles the previous bet amount.'),
                Text('- Scroll to see the full progression sequence.'),
                SizedBox(height: 10),
                Text('Example: Base \$10 → \$10, \$20, \$40, \$80, \$160...'),
                SizedBox(height: 10),
                Text('Disclaimer: Betting systems do not guarantee profits and involve risk.'),
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Martingale Scroller'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _showInfoDialog,
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: baseBetController,
                      decoration: InputDecoration(
                        labelText: 'Enter base bet amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple.shade50,
                      ),
                      onSubmitted: (_) => compute(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: compute,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('compute'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _martingaleSequence.length +
                    (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _martingaleSequence.length) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  final betAmount = _martingaleSequence[index];
                  final cumulativeCapital = _martingaleSequence
                      .sublist(0, index + 1)
                      .fold<int>(0, (prev, e) => prev + e);
      
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'M(${index + 1}): ${betAmount.toString()}',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total capital needed: \$$cumulativeCapital',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
