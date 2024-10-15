import 'package:flutter/material.dart';
import 'package:rngjff/presentation/screens/dice_game.dart';
import 'package:rngjff/presentation/screens/random_number.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RandomName(
                      title: "Random Name",
                    ),
                  ),
                );
              },
              child: const Text(
                "Random Name",
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
                "Randome Numbers",
                style: TextStyle(fontSize: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
