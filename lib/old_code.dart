// class RandomName extends StatefulWidget {
//   final String title;
//   const RandomName({super.key, required this.title});

//   @override
//   _RandomNameState createState() => _RandomNameState();
// }

// class _RandomNameState extends State<RandomName> {
//   List<String> names = [];
//   String currentName = "";
//   TextEditingController nameController = TextEditingController();
//   final Random _random = Random();

//   void addToList() {
//     if (nameController.text.isNotEmpty) {
//       setState(() {
//         names.add(nameController.text);
//       });
//     }
//   }

//   Future<void> _showMyDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Info'),
//           content: const SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 Text('Swipe left or right to remove entered name'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Go it'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: GestureDetector(
//               onTap: _showMyDialog,
//               child: const Icon(Icons.info_outline),
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Center(
//                 child: ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: names.length,
//                   itemBuilder: (context, index) {
//                     return Dismissible(
//                       key: UniqueKey(),
//                       onDismissed: (direction) {
//                         setState(() {
//                           names.removeAt(index);
//                         });
//                       },
//                       child: ListTile(
//                         title: Text("${index + 1}. ${names[index]}"),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text("Add name"),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: nameController,
//                         decoration: const InputDecoration(
//                           enabledBorder: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(color: Colors.green, width: 1.0),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(14.0))),
//                           contentPadding: EdgeInsets.all(8),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           addToList();
//                           nameController.clear();
//                         },
//                         child: const Text("Add"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _generateRandomName,
//             child: const Text("Generate Random Name"),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Builder(
//               builder: (context) => ElevatedButton(
//                 onPressed: () {
//                   if (names.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         behavior: SnackBarBehavior.floating,
//                         content: Text(
//                           "LIST HAS NO NAME ",
//                         ),
//                       ),
//                     );
//                   } else {
//                     setState(() {
//                       var randomNumber = Random();
//                       String name = names[randomNumber.nextInt(names.length)];
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         behavior: SnackBarBehavior.floating,
//                         content: Text(
//                           "Name You got $name",
//                         ),
//                       ));
//                       names.remove(name);
//                     });
//                   }
//                 },
//                 child: const Text("Get Name"),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16)
//         ],
//       ),
//     );
//   }

//   void _generateRandomName() {
//     setState(() {
//       final String randomFirstName =
//           firstNames[_random.nextInt(firstNames.length)];
//       final String randomLastName =
//           lastNames[_random.nextInt(lastNames.length)];
//       currentName = '$randomFirstName $randomLastName';
//       names.add(currentName);
//     });
//   }
// }

//! -----

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const RouletteBoardApp());
// }

// // Main application widget
// class RouletteBoardApp extends StatelessWidget {
//   const RouletteBoardApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Roulette Board',
//       theme: ThemeData(
//         primarySwatch: Colors.green, // Roulette theme color
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const RouletteBoardPage(),
//       debugShowCheckedModeBanner: false, // Hide the debug banner
//     );
//   }
// }

// // Widget to display the Roulette Board
// class RouletteBoardPage extends StatelessWidget {
//   const RouletteBoardPage({super.key});

//   // Helper function to get the color for a roulette number
//   Color _getNumberColor(int number) {
//     if (number == 0 || number == 37) {
//       // 37 for '00' in this representation
//       return Colors.green.shade700;
//     }
//     // Standard American Roulette colors
//     // Red: 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
//     // Black: 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35
//     if ([1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
//         .contains(number)) {
//       return Colors.red.shade700;
//     }
//     return Colors.black87; // Default to black for others
//   }

//   Widget _buildRowSection() {
//     // Build 12 rows for the roulette numbers
//     return Column(
//       children: List.generate(12, (i) {
//         return Row(
//           children: [
//             // Column 1 (e.g., 1, 4, 7...)
//             _buildNumberCell('${(3 * i) + 1}', _getNumberColor((3 * i) + 1)),
//             // Column 2 (e.g., 2, 5, 8...)
//             _buildNumberCell('${(3 * i) + 2}', _getNumberColor((3 * i) + 2)),
//             // Column 3 (e.g., 3, 6, 9...)
//             _buildNumberCell('${(3 * i) + 3}', _getNumberColor((3 * i) + 3)),
//             // 2 to 1 cell
//             // if (i == 3 ||
//             //     i == 7 ||
//             //     i == 11) // Only show "2 to 1" on specific rows
//             //   _buildTwoToOneCell(),
//           ],
//         );
//       }),
//     );
//   }

//   // Helper widget to build individual number cells
//   Widget _buildNumberCell(String numberText, Color color,
//       {double heightFactor = 1.0, VoidCallback? onTap}) {
//     return Expanded(
//       child: AspectRatio(
//         aspectRatio:
//             1.0 / heightFactor, // Maintain aspect ratio for height variations
//         child: Container(
//           margin: const EdgeInsets.all(2.0),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius:
//                 BorderRadius.circular(4.0), // Slightly rounded corners
//             border:
//                 Border.all(color: Colors.white54, width: 0.5), // Subtle border
//           ),
//           child: InkWell(
//             // Use InkWell for tap feedback
//             onTap: onTap,
//             child: Center(
//               child: Text(
//                 numberText,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18.0,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper widget to build the "2 to 1" cells at the end of rows
//   Widget _buildTwoToOneCell() {
//     return Expanded(
//       child: AspectRatio(
//         aspectRatio: 1.0,
//         child: Container(
//           margin: const EdgeInsets.all(2.0),
//           decoration: BoxDecoration(
//             color: Colors.green.shade900,
//             borderRadius: BorderRadius.circular(4.0),
//             border: Border.all(color: Colors.white54, width: 0.5),
//           ),
//           child: const Center(
//             child: Text(
//               '2 to 1',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14.0,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Roulette Board'),
//         centerTitle: true,
//         backgroundColor: Colors.green.shade900,
//       ),
//       backgroundColor:
//           Colors.green.shade200, // Light green background for the app
//       body: SingleChildScrollView(
//         // Allow scrolling if content overflows
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // 0 section
//                     SizedBox(
//                       height: 100,
//                       width: 300,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           _buildNumberCell('0', _getNumberColor(0),
//                               heightFactor:
//                                   2.0), // 0 cell (taller)// 00 cell (taller)
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                         height: 8.0), // Space between 0/00 and main grid

//                     SizedBox(
//                       width: 300,
//                       child: _buildRowSection(),
//                     ),

//                     const SizedBox(height: 8.0), // Space below main grid

//                     // Bottom betting areas (simplified example)
//                     SizedBox(
//                       width: 300,
//                       child: Row(
//                         children: <Widget>[
//                           _buildNumberCell('1st Col', Colors.blueGrey.shade800),
//                           _buildNumberCell('2nd Col', Colors.blueGrey.shade800),
//                           _buildNumberCell('3rd Col', Colors.blueGrey.shade800),
//                         ],
//                       ),
//                     ),
//                     // SizedBox(
//                     //   width: 500,
//                     //   child: Row(
//                     //     children: <Widget>[
//                     //       _buildNumberCell('1-18', Colors.blueGrey.shade800),
//                     //       _buildNumberCell('EVEN', Colors.blueGrey.shade800),
//                     //       _buildNumberCell('RED', Colors.red.shade700),
//                     //       _buildNumberCell('BLACK', Colors.black87),
//                     //       _buildNumberCell('ODD', Colors.blueGrey.shade800),
//                     //       _buildNumberCell('19-36', Colors.blueGrey.shade800),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//! -----------------------

// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class CoinFlipPage extends StatefulWidget {
//   const CoinFlipPage({super.key});

//   @override
//   _CoinFlipPageState createState() => _CoinFlipPageState();
// }

// class _CoinFlipPageState extends State<CoinFlipPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//   bool isHeads = true; // To track which side is currently visible

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1), // Duration for one flip
//     );

//     _rotationAnimation = Tween<double>(begin: 0, end: math.pi).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut, // For a smoother, more realistic flip
//       ),
//     )..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           setState(() {
//             isHeads = !isHeads; // Toggle the side after half a flip
//           });
//           _controller.value = 0; // Reset for the next flip
//         }
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _startFlip() {
//     _controller.forward(from: 0.0); // Start the animation
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('3D Coin Flip Animation'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedBuilder(
//               animation: _rotationAnimation,
//               builder: (context, child) {
//                 final angle = _rotationAnimation.value;
//                 final isFront =
//                     angle < math.pi / 2; // Check if front side is visible

//                 return Transform(
//                   alignment: FractionalOffset.center,
//                   transform: Matrix4.identity()
//                     ..setEntry(3, 2, 0.001) // Add perspective
//                     ..rotateY(angle), // Rotate around Y-axis
//                   child: Image.asset(
//                     isFront
//                         ? 'images/coin_heads.png'
//                         : 'images/coin_tails.png', // Replace with your coin images
//                     width: 200,
//                     height: 200,
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 50),
//             ElevatedButton(
//               onPressed: _startFlip,
//               child: const Text('Flip Coin'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
