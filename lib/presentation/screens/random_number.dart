import 'dart:math';
import 'package:flutter/material.dart';


class RandomNumberGenerator extends StatefulWidget {
  const RandomNumberGenerator({super.key});
 
  @override 
  _RandomNumberGeneratorState createState() => _RandomNumberGeneratorState(); 
} 
  
class _RandomNumberGeneratorState extends State<RandomNumberGenerator> { 
  final Random _random = 
      Random(); // Create a Random object for generating random numbers 
  int _randomNumber = 0; 
    
  // Method ffor generating a random 4 digit number 
  void generateRandomNumber() { 
    setState(() { 
      _randomNumber = 
          1000 + _random.nextInt(9000); // Generates a random 4-digit number 
    },); 
  } 
  
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Random 4-Digit Number Generator'), 
      ), 
      body: Center( 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
            const Text( 
              'Random 4-Digit Number:', // Display a label for the random number 
              style: TextStyle(fontSize: 20), 
            ), 
            Text( 
              '$_randomNumber', // Display the generated random number 
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold), 
            ), 
            const SizedBox(height: 20), 
            ElevatedButton( 
              onPressed: 
                  generateRandomNumber, // Call the function to generate a random number 
              child: const Text( 
                  'Generate Random 4-Digit Number'), // Button to trigger number generation 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
} 