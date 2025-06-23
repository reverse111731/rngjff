import 'package:flutter/material.dart';

class FibonacciListPage extends StatefulWidget {
  const FibonacciListPage({super.key});

  @override
  _FibonacciListPageState createState() => _FibonacciListPageState();
}

class _FibonacciListPageState extends State<FibonacciListPage> {
  // Use BigInt to handle large Fibonacci numbers
  final List<BigInt> _fibNumbers = [BigInt.from(1)];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false; // To prevent multiple calls while loading
  final TextEditingController unitController = TextEditingController();
  int unit = 1;

  @override
  void initState() {
    super.initState();
    // Add a listener to the scroll controller
    _scrollController.addListener(_onScroll);
    // Generate an initial set of numbers to fill the screen
    _generateMoreFibonacci();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void compute() {
    final String inputUnit = unitController.text.trim();
    final int parsedUnit = int.tryParse(inputUnit)!;

    setState(() {
      unit = parsedUnit;
    });
  }

  // Listener for scroll events
  void _onScroll() {
    // Check if the user has scrolled to the end of the list
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _generateMoreFibonacci();
    }
  }

  // Function to generate the next batch of Fibonacci numbers
  void _generateMoreFibonacci() {
    setState(() {
      _isLoadingMore = true; // Set loading state
    });

    // Simulate a slight delay for generating (e.g., if fetching from an API)
    Future.delayed(Duration(milliseconds: 500), () {
      int countToAdd = 20; // Number of Fibonacci numbers to add per scroll
      for (int i = 0; i < countToAdd; i++) {
        if (_fibNumbers.length < 2) {
          // Handle initial case if list is too small (shouldn't happen with [0, 1])
          if (_fibNumbers.isEmpty) {
            _fibNumbers.add(BigInt.from(0));
          } else if (_fibNumbers.length == 1) {
            _fibNumbers.add(BigInt.from(1));
          }
        } else {
          // Calculate the next Fibonacci number
          BigInt nextFib = _fibNumbers[_fibNumbers.length - 1] +
              _fibNumbers[_fibNumbers.length - 2];
          _fibNumbers.add(nextFib);
        }
      }
      setState(() {
        _isLoadingMore = false; // Reset loading state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fibonacci Scroller'),
        centerTitle: true,
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
                    controller: unitController,
                    decoration: InputDecoration(
                      labelText: 'Enter a number to compute Fibonacci',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
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
                    backgroundColor: Colors.blueAccent,
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
              controller: _scrollController, // Attach the scroll controller
              itemCount: _fibNumbers.length +
                  (_isLoadingMore ? 1 : 0), // Add 1 for loading indicator
              itemBuilder: (context, index) {
                if (index == _fibNumbers.length) {
                  // This is the loading indicator at the bottom
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                // Display each Fibonacci number
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'F($index): ${_fibNumbers[index].toString()} = ${_fibNumbers[index] * BigInt.from(unit)}',
                      // Display the Fibonacci number and its index
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
