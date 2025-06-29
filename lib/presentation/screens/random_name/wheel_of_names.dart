import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../index.dart';

class WheelOfNamesScreen extends StatefulWidget {
  const WheelOfNamesScreen({super.key});
  //   final Random random = Random();

  @override
  State<WheelOfNamesScreen> createState() => _WheelOfNamesScreenState();
}

class _WheelOfNamesScreenState extends State<WheelOfNamesScreen> {
  // Controller for the input field to add new names
  final TextEditingController nameInputController = TextEditingController();
  final Random random = Random();
  String tempName = "";

  // List to hold the names on the wheel
  final List<String> names = [];

  // StreamController to control the FortuneWheel's spin.
  // We add an integer (the index of the desired item) to this stream to trigger a spin.
  final StreamController<int> selected = StreamController<int>.broadcast();

  // This variable will store the index of the item that was targeted for the spin.
  // This is needed because onAnimationEnd doesn't directly return the index.
  int? targetSpinIndex;

  @override
  void dispose() {
    nameInputController.dispose();
    selected.close(); // Close the stream when the widget is disposed
    super.dispose();
  }

  // Function to add a name to the wheel
  void addName() {
    final String newName = nameInputController.text.trim();
    if (newName.isNotEmpty) {
      setState(() {
        names.add(newName);
        nameInputController.clear(); // Clear the input field
      });
      showMessage('"$newName" added to the wheel!');
    } else {
      showMessage('Please enter a name.');
    }
  }

  // New function to remove a name by index
  void removeName(int index) {
    if (index >= 0 && index < names.length) {
      final String removedName = names[index];
      setState(() {
        names.removeAt(index);
      });
      showMessage('$removedName removed from the list.');
    }
  }

  // Function to spin the wheel
  void spinWheel() {
    if (names.isEmpty) {
      showMessage('Add some names to the wheel first!');
      return;
    }

    // Generate a random index to spin to
    final int randomIndex = Fortune.randomInt(0, names.length);
    targetSpinIndex = randomIndex; // Store the target index

    // Add the target index to the stream to start the spin animation
    selected.add(randomIndex);
  }

  // Callback for when the wheel animation ends
  void onSpinAnimationEnd() {
    if (targetSpinIndex != null && names.isNotEmpty) {
      final String selectedName = names[targetSpinIndex!];

      // Remove the selected name from the list
      setState(() {
        names.removeAt(targetSpinIndex!);
        targetSpinIndex = null; // Clear the target index
      });

      // showMessage('🎉 $selectedName was selected and removed! 🎉');
      showComingSoonModal(context, selectedName);
    }
  }

  void generateRandomName() {
    setState(() {
      final String randomFirstName =
          firstNames[random.nextInt(firstNames.length)];
      final String randomLastName = lastNames[random.nextInt(lastNames.length)];
      tempName = '$randomFirstName $randomLastName';
      names.add(tempName);
    });
  }

  // Helper function to show a SnackBar message
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wheel of Names'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field and Add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameInputController,
                    decoration: InputDecoration(
                      labelText: 'Enter a name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    onSubmitted: (_) => addName(), // Add on pressing Enter
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Name'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: generateRandomName,
              child: const Text("Generate Random Name"),
            ),

            const SizedBox(height: 16),

            // Spin Button
            ElevatedButton(
              onPressed: (names.isEmpty || names.length == 1)
                  ? null
                  : spinWheel, // Disable if no names
              style: ElevatedButton.styleFrom(
                backgroundColor: (names.isEmpty || names.length == 1)
                    ? Colors.grey
                    : Colors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
                (names.isEmpty || names.length == 1)
                    ? 'Add names to spin!'
                    : 'Spin the Wheel!',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            // Wheel of Names
            Expanded(
              child: names.isEmpty || names.length == 1
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              size: 60, color: Colors.amber.shade700),
                          const SizedBox(height: 8),
                          Text(
                            names.length == 1
                                ? 'Add 1 more name to start the wheel!'
                                : 'Add 2 names above to start the wheel!',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade700),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : FortuneWheel(
                      selected: selected.stream,
                      animateFirst: false,
                      // The list of FortuneItems, created dynamically from names
                      items: [
                        for (var name in names)
                          FortuneItem(
                            child: Center(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // Optional: Customize item styles
                            style: FortuneItemStyle(
                              color: Colors.primaries[Random().nextInt(
                                  Colors.primaries.length)], // Random color
                              borderColor: Colors.black,
                              borderWidth: 2,
                            ),
                          ),
                      ],
                      onAnimationEnd: onSpinAnimationEnd,
                      // Customize indicator (the pointer)
                      indicators: const <FortuneIndicator>[
                        FortuneIndicator(
                          alignment:
                              Alignment.topCenter, // Alignment of the indicator
                          child: TriangleIndicator(
                            color: Colors.redAccent, // Color of the indicator
                            width: 25, // Width of the indicator
                            height: 25, // Height of the indicator
                          ),
                        ),
                      ],
                      // Customize physics for a more natural feel
                      physics: CircularPanPhysics(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                      ),
                      // Set total rotations for a good spin effect
                      rotationCount: 8,
                      // Set total duration for the animation
                      duration: const Duration(seconds: 3),
                    ),
            ),
            const SizedBox(height: 16),

            // Display current names in the wheel
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Names on Wheel (${names.length}):',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: names.isEmpty ? 0 : 1,
              child: names.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      itemCount: names.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 0),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              // <-- Changed to Row
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // <-- Aligns text and button
                              children: [
                                Expanded(
                                  // <-- Ensures text takes available space
                                  child: Text(
                                    names[index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  // <-- Added IconButton
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () => removeName(
                                      index), // Call the new remove function
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void showComingSoonModal(BuildContext context, String selectedName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(selectedName),
        content: const Text('Congratulations!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
