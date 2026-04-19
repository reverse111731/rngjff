import 'dart:math';
import 'package:flutter/material.dart';

class CoinFlipHomePage extends StatefulWidget {
  const CoinFlipHomePage({super.key});

  @override
  State<CoinFlipHomePage> createState() => _CoinFlipHomePageState();
}

class _CoinFlipHomePageState extends State<CoinFlipHomePage>
    with SingleTickerProviderStateMixin {
  //? 0 for heads, 1 for tails
  int coinSide = 0;
  final Random random = Random();
  //? To control animation/interaction during flip
  bool isFlipping = false;

  void flipCoin() {
    if (isFlipping) return; // Prevent multiple flips while animating

    setState(() {
      isFlipping = true;
    });

    // Simulate a short delay for a "flipping" animation effect
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        coinSide = random.nextInt(2); // Randomly choose 0 (heads) or 1 (tails)
        isFlipping = false; // Reset flipping state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Flip'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: flipCoin, // Flip on coin tap
                child: AnimatedContainer(
                  duration: const Duration(
                      milliseconds: 300), // Smooth animation for scaling
                  curve: Curves.easeInOut,
                  width: isFlipping
                      ? 250
                      : 200, // Slightly scale down when flipping
                  height: isFlipping ? 250 : 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          coinSide == 0 ? 'Heads' : 'Tails',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: coinSide == 0 ? Colors.blue : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Button to flip the coin
              ElevatedButton(
                onPressed: flipCoin, // Flip on button press
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Rounded corners for button
                  ),
                  elevation: 8, // Add shadow to button
                  // Button color with a subtle gradient
                  backgroundColor: Colors.blueGrey[700],
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  isFlipping ? 'Flipping...' : 'FLIP COIN',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
