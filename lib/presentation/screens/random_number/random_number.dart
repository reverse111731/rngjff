import 'dart:math';
import 'package:flutter/material.dart';

class RandomNumberGenerator extends StatefulWidget {
  const RandomNumberGenerator({super.key});

  @override
  RandomNumberGeneratorState createState() => RandomNumberGeneratorState();
}

class RandomNumberGeneratorState extends State<RandomNumberGenerator> {
  int _selectedDigits = 1; // Default number of digits
  String _generatedNumber = '---'; // Placeholder for the generated number
  final Random _random = Random(); // Instance of Random for number generation

  // Function to generate a random number based on the selected number of digits
  void _generateRandomNumber() {
    int min, max;
    switch (_selectedDigits) {
      case 0:
        min = 0;
        max = 9999;
        break;
      case 1:
        min = 0;
        max = 9;
        break;
      case 2:
        min = 10;
        max = 99;
        break;
      case 3:
        min = 100;
        max = 999;
        break;
      case 4:
        min = 1000;
        max = 9999;
        break;
      case 5:
        min = 10000;
        max = 99999;
        break;
      default:
        min = 0;
        max = 99999;
    }

    // Generate a random integer within the specified range [min, max]
    // nextInt(n) generates a random non-negative integer uniformly distributed in the range from 0 (inclusive) to n (exclusive).
    // So, to get a number between min and max (inclusive), we use min + _random.nextInt(max - min + 1)
    int randomNumber = min + _random.nextInt(max - min + 1);

    setState(() {
      _generatedNumber = randomNumber.toString(); // Update the displayed number
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Number Generator'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Dropdown to select the number of digits
              const Text(
                'Select number of digits:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              DropdownButton<int>(
                value: _selectedDigits,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple, fontSize: 20),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedDigits = newValue!; // Update the selected digits
                    _generatedNumber = '---'; // Reset displayed number
                  });
                },
                items:
                    [0, 1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('${value == 0 ? 'N' : value} - digits'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              // Display area for the generated number
              const Text(
                'Generated Number:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                _generatedNumber,
                style: const TextStyle(
                  fontSize: 48, // Large font for visibility
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 50),
              // Button to generate the random number
              ElevatedButton(
                onPressed:
                    _generateRandomNumber, // Call the generation function
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Rounded corners for the button
                  ),
                  backgroundColor:
                      Colors.blueGrey[700], // Darker shade for the button
                  foregroundColor: Colors.white, // Text color
                ),
                child: const Text(
                  'Generate Random Number',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
