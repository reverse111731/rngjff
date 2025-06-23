import 'dart:math';

import 'package:flutter/material.dart';

class MartingalePage extends StatefulWidget {
  const MartingalePage({super.key});

  @override
  _MartingalePageState createState() => _MartingalePageState();
}

class _MartingalePageState extends State<MartingalePage> {
  int baseBet = 10;
  int currentBet = 10;
  int balance = 1000;
  String lastResult = '';
  Random random = Random();

  void _bet() {
    bool win = random.nextBool(); // Simulate win/loss (50/50)
    setState(() {
      if (win) {
        balance += currentBet;
        lastResult = 'Win! Bet: \$$currentBet';
        currentBet = baseBet; // Reset bet after win
      } else {
        balance -= currentBet;
        lastResult = 'Lose! Bet: \$$currentBet';
        currentBet *= 2; // Double bet after loss
      }
      if (currentBet > balance) {
        currentBet = balance; // Prevent betting more than balance
      }
    });
  }

  void _reset() {
    setState(() {
      balance = 1000;
      currentBet = baseBet;
      lastResult = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Martingale Simulator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Balance: \$$balance', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Current Bet: \$$currentBet', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text(lastResult, style: TextStyle(fontSize: 18)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: balance > 0 ? _bet : null,
              child: Text('Bet'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _reset,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
