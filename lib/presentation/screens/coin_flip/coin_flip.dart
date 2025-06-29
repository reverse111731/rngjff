import 'dart:math';
import 'package:flutter/material.dart';

class CoinFlipHomePage extends StatefulWidget {
  const CoinFlipHomePage({super.key});

  @override
  State<CoinFlipHomePage> createState() => _CoinFlipHomePageState();
}

class _CoinFlipHomePageState extends State<CoinFlipHomePage>
    with SingleTickerProviderStateMixin {
  //? 0 for heads, 1 for tails
  int coinSide = 0;
  final Random random = Random();
  //? To control animation/interaction during flip
  bool isFlipping = false;

  void flipCoin() {
    if (isFlipping) return; // Prevent multiple flips while animating

    setState(() {
      isFlipping = true;
    });

    // Simulate a short delay for a "flipping" animation effect
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        coinSide = random.nextInt(2); // Randomly choose 0 (heads) or 1 (tails)
        isFlipping = false; // Reset flipping state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Flip'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: flipCoin, // Flip on coin tap
                child: AnimatedContainer(
                  duration: const Duration(
                      milliseconds: 300), // Smooth animation for scaling
                  curve: Curves.easeInOut,
                  width: isFlipping
                      ? 250
                      : 200, // Slightly scale down when flipping
                  height: isFlipping ? 250 : 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          coinSide == 0 ? 'Heads' : 'Tails',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: coinSide == 0 ? Colors.blue : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Button to flip the coin
              ElevatedButton(
                onPressed: flipCoin, // Flip on button press
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Rounded corners for button
                  ),
                  elevation: 8, // Add shadow to button
                  // Button color with a subtle gradient
                  backgroundColor: Colors.blueGrey[700],
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  isFlipping ? 'Flipping...' : 'FLIP COIN',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'dart:math';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const CoinFlipApp());
// }

// class CoinFlipApp extends StatelessWidget {
//   const CoinFlipApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '3D Coin Flip',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         fontFamily: 'Inter', // Using Inter font as requested
//       ),
//       home: const CoinFlipHomePage(),
//     );
//   }
// }

// class CoinFlipHomePage extends StatefulWidget {
//   const CoinFlipHomePage({super.key});

//   @override
//   State<CoinFlipHomePage> createState() => _CoinFlipHomePageState();
// }

// class _CoinFlipHomePageState extends State<CoinFlipHomePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool _isHeads = true; // True for heads, false for tails
//   bool _isFlipping = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration:
//           const Duration(milliseconds: 1500), // Duration of one flip rotation
//     );

//     // This animation will control the Y-axis rotation for the 3D effect
//     _animation = Tween<double>(begin: 0, end: pi * 2).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutCubic, // Smooth acceleration and deceleration
//       ),
//     );

//     // Listener to update coin side after a full rotation or at the end of the flip
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() {
//           _isFlipping = false;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _flipCoin() {
//     if (_isFlipping) return; // Prevent multiple flips while animating

//     setState(() {
//       _isFlipping = true;
//     });

//     final Random random = Random();
//     // Decide the final outcome (true for heads, false for tails)
//     final bool resultIsHeads = random.nextBool();

//     // Determine the number of full rotations (e.g., 5 to 10 for a good flip effect)
//     final int numberOfFullRotations =
//         5 + random.nextInt(6); // 5 to 10 rotations
//     final double endAngle = numberOfFullRotations * pi * 2 +
//         (resultIsHeads ? 0 : pi); // End on heads (0) or tails (pi)

//     _animation = Tween<double>(begin: _animation.value, end: endAngle).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutCubic,
//       ),
//     );

//     // Reset and start the animation
//     _controller.reset();
//     _controller.forward().then((_) {
//       // After the animation completes, update the state to reflect the final side
//       setState(() {
//         _isHeads = resultIsHeads;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('3D Coin Flip'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // The AnimatedBuilder rebuilds the child whenever the animation value changes
//             AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 // Apply a 3D rotation transform to the coin
//                 // The Matrix4.identity() creates a 4x4 identity matrix
//                 // .setEntry(3, 2, 0.001) adds perspective (smaller value = more perspective)
//                 // .rotateY(_animation.value) rotates around the Y-axis based on animation value
//                 return Transform(
//                   alignment: Alignment.center,
//                   transform: Matrix4.identity()
//                     ..setEntry(3, 2, 0.001) // Perspective
//                     ..rotateY(_animation.value),
//                   child: SizedBox(
//                     width: 200, // Coin size
//                     height: 200,
//                     child: _isFlipping ||
//                             (_animation.value % (2 * pi) < pi / 2 ||
//                                 _animation.value % (2 * pi) > 3 * pi / 2)
//                         ? Image.asset(
//                             'assets/images/dice-1.png') // Show heads during the first quarter/last quarter of rotation or if flipping
//                         : Image.asset(
//                             'assets/images/dice-2.png'), // Show tails during the middle halves of rotation
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 50),
//             ElevatedButton(
//               onPressed: _flipCoin,
//               style: ElevatedButton.styleFrom(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                 textStyle: const TextStyle(fontSize: 20),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 elevation: 5,
//                 shadowColor: Colors.blueAccent.withOpacity(0.5),
//               ),
//               child: _isFlipping
//                   ? const Text('Flipping...')
//                   : const Text('Flip Coin'),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               _isFlipping
//                   ? '...'
//                   : (_isHeads ? 'Result: Heads!' : 'Result: Tails!'),
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
