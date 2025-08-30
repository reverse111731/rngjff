import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'index.dart';

class SelectionPageV2 extends StatelessWidget {
  final String title;

  const SelectionPageV2({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final List<_SelectionItem> items = [
      _SelectionItem(
        label: "Wheel of Names",
        fontSize: 32,
        builder: (context) => const WheelOfNamesScreen(),
      ),
      _SelectionItem(
        label: "Dice",
        fontSize: 32,
        builder: (context) => const GradientContainer(
          Colors.purple,
          Colors.deepPurple,
        ),
      ),
      _SelectionItem(
        label: "Random Numbers",
        fontSize: 32,
        builder: (context) => const RandomNumberGenerator(),
      ),
      _SelectionItem(
        label: "Coin Flip",
        fontSize: 32,
        builder: (context) => const CoinFlipHomePage(),
      ),
      _SelectionItem(
        label: "Random Name Generator",
        fontSize: 28,
        builder: (context) => const NameGeneratorHomePage(),
      ),
      _SelectionItem(
        label: "Fibonacci Scroller",
        fontSize: 32,
        builder: (context) => const FibonacciListPage(),
      ),
      _SelectionItem(
        label: "Roulette Board Guide",
        fontSize: 32,
        builder: (context) => const RouletteBoardPage(),
      ),
      _SelectionItem(
        label: "Labouchere System",
        fontSize: 32,
        builder: (context) => const LabouchereHomePage(),
      ),
      _SelectionItem(
        label: "Martingale System",
        fontSize: 32,
        builder: (context) => const MartingaleHomePage(),
      ),
      _SelectionItem(
        label: "Roulette Wheel",
        fontSize: 32,
        builder: (context) => const RouletteWheel(),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.grey.shade400,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              iconSize: 32,
              color: Colors.black,
              tooltip: 'Reload',
              onPressed: () {
                // Reload the screen by rebuilding the widget
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        SelectionPageV2(title: title),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GridView.count(
            crossAxisCount:
                kIsWeb ? 2 : (Platform.isAndroid || Platform.isIOS ? 1 : 2),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 5,
            children: items.map((item) {
              final Color randomColor = Colors
                  .primaries[(items.indexOf(item) + DateTime.now().second) %
                      Colors.primaries.length]
                  .shade900;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: randomColor,
                  foregroundColor:
                      ThemeData.estimateBrightnessForColor(randomColor) ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: item.builder),
                  );
                },
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: item.fontSize),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _SelectionItem {
  final String label;
  final double fontSize;
  final WidgetBuilder builder;

  _SelectionItem({
    required this.label,
    required this.fontSize,
    required this.builder,
  });
}
