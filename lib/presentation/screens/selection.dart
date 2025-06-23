import 'package:flutter/material.dart';

import 'index.dart';

class SelectionPage extends StatelessWidget {
  final String title;

  const SelectionPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: SelectionScreenKey,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WheelOfNamesScreen(),
                  ),
                );
              },
              child: const Text(
                "Wheel of Names",
                style: TextStyle(fontSize: 32),
              ),
            ),
            //!----
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GradientContainer(
                      Colors.purple,
                      Colors.deepPurple,
                    ),
                  ),
                );
              },
              child: const Text(
                "Dice",
                style: TextStyle(fontSize: 32),
              ),
            ),
            //!--
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RandomNumberGenerator(),
                  ),
                );
              },
              child: const Text(
                "Random Numbers",
                style: TextStyle(fontSize: 32),
              ),
            ),
            //!--
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CoinFlipHomePage(),
                  ),
                );
              },
              child: const Text(
                "Coin Flip",
                style: TextStyle(fontSize: 32),
              ),
            ),
            //!--
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NameGeneratorHomePage(),
                  ),
                );
              },
              child: const Text(
                "Random Name Generator",
                style: TextStyle(fontSize: 28),
              ),
            ),
            //!--
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FibonacciListPage(),
                  ),
                );
              },
              child: const Text(
                "Fibonacci Scroller",
                style: TextStyle(fontSize: 32),
              ),
            ),
            //!--
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RouletteBoardPage(),
                  ),
                );
              },
              child: const Text(
                "Roulette Board",
                style: TextStyle(fontSize: 32),
              ),
            ),
            //!--
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LabouchereHomePage(),
                  ),
                );
              },
              child: const Text(
                "Labouchere",
                style: TextStyle(fontSize: 32),
              ),
            ),
            //!--
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MartingalePage(),
                  ),
                );
              },
              child: const Text(
                "Martingale",
                style: TextStyle(fontSize: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
