// import 'dart:math';
// import 'package:flutter/material.dart';

// const startAlignment = Alignment.topLeft;
// const endAlignment = Alignment.bottomRight;

// class GradientContainer extends StatelessWidget {
//   const GradientContainer(this.color1, this.color2, {super.key});

//   final Color color1;
//   final Color color2;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: startAlignment,
//           end: endAlignment,
//           colors: [color1, color2],
//         ),
//       ),
//       child: const Center(child: DiceRoller()),
//     );
//   }
// }

// class DiceRoller extends StatefulWidget {
//   const DiceRoller({super.key});

//   @override
//   State<DiceRoller> createState() => _DiceRollerState();
// }

// class _DiceRollerState extends State<DiceRoller> {
//   final randomizer = Random();
//   var currentDiceRoll = 1;

//   void rollDice() {
//     setState(() {
//       currentDiceRoll = randomizer.nextInt(6) + 1;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           'assets/images/dice-$currentDiceRoll.png',
//           width: 200,
//         ),
//         const SizedBox(height: 20),
//         TextButton(
//           style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//               textStyle: const TextStyle(
//                 fontSize: 28,
//               )),
//           onPressed: rollDice,
//           child: const Text('Roll Dice'),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         TextButton(
//           style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//               textStyle: const TextStyle(
//                 fontSize: 28,
//               )),
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Go back to selection'),
//         ),
//       ],
//     );
//   }
// }

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: startAlignment, // Start the gradient from top-left
          end: endAlignment, // End the gradient at bottom-right
          colors: [color1, color2], // Use the provided colors for the gradient
        ),
      ),
      // Center the DiceRoller widget within the container
      child: const Center(child: DiceRoller()),
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
      // Clear the current rolls and re-populate based on selected dice count
      _currentDiceRolls.clear();
      _totalDiceCount = 0;
      for (int i = 0; i < _selectedDiceCount; i++) {
        // Generate a random number between 1 and 6 for each die
        _currentDiceRolls.add(randomizer.nextInt(6) + 1);
        _totalDiceCount += _currentDiceRolls[i];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly, // Center content vertically
      children: [
        // Display dice images based on _currentDiceRolls

        // Radio button selector for number of dice
        // Wrapped in Material widget to resolve the "Material ancestor" error
        Material(
          color: Colors
              .transparent, // Make the material transparent to show the gradient
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                // Radio button for 1 die
                Flexible(
                  child: RadioListTile<int>(
                    title: const Text('1 Die',
                        style: TextStyle(color: Colors.white)),
                    value: 1,
                    groupValue: _selectedDiceCount,
                    onChanged: (value) {
                      setState(() {
                        _selectedDiceCount = value!;
                        _totalDiceCount = _selectedDiceCount;
                        _currentDiceRolls = [
                          1
                        ]; // Reset to 1 die when count changes
                      });
                    },
                    activeColor:
                        Colors.white, // Color of the selected radio button
                    contentPadding: EdgeInsets.zero, // Remove default padding
                  ),
                ),
                // Radio button for 2 dice
                Flexible(
                  child: RadioListTile<int>(
                    title: const Text('2 Dice',
                        style: TextStyle(color: Colors.white)),
                    value: 2,
                    groupValue: _selectedDiceCount,
                    onChanged: (value) {
                      setState(() {
                        _selectedDiceCount = value!;
                        _totalDiceCount = _selectedDiceCount;
                        _currentDiceRolls = [
                          1,
                          1
                        ]; // Reset to 2 dice when count changes
                      });
                    },
                    activeColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                // Radio button for 3 dice
                Flexible(
                  child: RadioListTile<int>(
                    title: const Text('3 Dice',
                        style: TextStyle(color: Colors.white)),
                    value: 3,
                    groupValue: _selectedDiceCount,
                    onChanged: (value) {
                      setState(() {
                        _selectedDiceCount = value!;
                        _totalDiceCount = _selectedDiceCount;
                        _currentDiceRolls = [
                          1,
                          1,
                          1
                        ]; // Reset to 3 dice when count changes
                      });
                    },
                    activeColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
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
