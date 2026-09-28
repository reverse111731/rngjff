import 'dart:math';
import 'package:flutter/material.dart';

// Define alignment constants for the gradient background
const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

// GradientContainer widget that provides a colored gradient background
class GradientContainer extends StatelessWidget {
  // Constructor requires two colors for the gradient
  const GradientContainer(this.color1, this.color2, {super.key});

  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: startAlignment, // Start the gradient from top-left
            end: endAlignment, // End the gradient at bottom-right
            colors: [
              color1,
              color2
            ], // Use the provided colors for the gradient
          ),
        ),
        // Center the DiceRoller widget within the container
        child: const Center(child: DiceRoller()),
        ),
      ),
    );
  }
}

// DiceRoller StatefulWidget to manage the state of the dice and their rolls
class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

// _DiceRollerState manages the internal state for the DiceRoller widget
class _DiceRollerState extends State<DiceRoller> {
  // Random number generator for dice rolls
  final randomizer = Random();
  // List to store the current roll values for each die
  List<int> _currentDiceRolls = [1];
  // Stores the number of dice selected by the user (default to 1)
  int _selectedDiceCount = 1;
  int _totalDiceCount = 1; // Total number of dice options available

  // Function to roll all selected dice
  void _rollAllDice() {
    setState(() {
      _currentDiceRolls = List.generate(
        _selectedDiceCount,
        (_) => randomizer.nextInt(6) + 1,
      );
      _totalDiceCount = _currentDiceRolls.fold(0, (sum, roll) => sum + roll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly, // Center content vertically
      children: [
        // Display dice images based on _currentDiceRolls

        // Radio button selector for number of dice using RadioGroup
        RadioGroup<int>(
          groupValue: _selectedDiceCount,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _selectedDiceCount = value;
              _totalDiceCount = _selectedDiceCount;
              _currentDiceRolls = List.generate(value, (_) => 1);
            });
          },
          child: Material(
            color: Colors
                .transparent, // Make the material transparent to show the gradient
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  // Radio button for 1 die
                  Flexible(
                    child: RadioListTile<int>(
                      title: Text('1 Die',
                          style: TextStyle(color: Colors.white)),
                      value: 1,
                      fillColor: WidgetStatePropertyAll(Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  // Radio button for 2 dice
                  Flexible(
                    child: RadioListTile<int>(
                      title: Text('2 Dice',
                          style: TextStyle(color: Colors.white)),
                      value: 2,
                      fillColor: WidgetStatePropertyAll(Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  // Radio button for 3 dice
                  Flexible(
                    child: RadioListTile<int>(
                      title: Text('3 Dice',
                          style: TextStyle(color: Colors.white)),
                      value: 3,
                      fillColor: WidgetStatePropertyAll(Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Text(_totalDiceCount.toString(),
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
            )),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _currentDiceRolls.map((roll) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(
                'assets/images/dice-$roll.png', // Path to dice image asset
                width: 100, // Width of each dice image
              ),
            );
          }).toList(),
        ),

        // Button to roll the dice
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 28,
            ),
          ),
          onPressed: _rollAllDice, // Call the function to roll all dice
          child: const Text('Roll Dice'),
        ),

        //! Button to navigate back (assuming it's part of a navigation stack)
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 28,
            ),
          ),
          onPressed: () => Navigator.pop(context), // Navigate back
          child: const Text('Go back to selection'),
        ),
      ],
    );
  }
}
