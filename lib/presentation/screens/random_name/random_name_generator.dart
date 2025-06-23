import 'dart:math';
import 'package:flutter/material.dart';
import '../index.dart';

class NameGeneratorHomePage extends StatefulWidget {
  const NameGeneratorHomePage({super.key});

  @override
  State<NameGeneratorHomePage> createState() => _NameGeneratorHomePageState();
}

class _NameGeneratorHomePageState extends State<NameGeneratorHomePage> {
  String currentName = "Generate a name"; // Initial text
  final Random random = Random();

  // Function to generate a random full name
  void generateRandomName() {
    setState(() {
      final String randomFirstName =
          firstNames[random.nextInt(firstNames.length)];
      final String randomLastName = lastNames[random.nextInt(lastNames.length)];
      currentName = '$randomFirstName $randomLastName';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Name Generator'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display for the generated name
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  currentName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ),
              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: generateRandomName,
                child: const Text('GENERATE NAME'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
