import 'package:flutter/material.dart';
import 'roulete_dialog.dart';

// Widget to display the Roulette Board
class RouletteBoardPage extends StatefulWidget {
  const RouletteBoardPage({super.key});

  @override
  State<RouletteBoardPage> createState() => _RouletteBoardPageState();
}

class _RouletteBoardPageState extends State<RouletteBoardPage> {
  bool doubleZeroEnabled = false;

  // Helper function to get the color for a roulette number
  Color _getNumberColor(int number) {
    if (number == 0 || number == 37) {
      return Colors.green.shade700;
    }
    // Standard American Roulette colors for numbers 1-36
    // Red: 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
    // Black: 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35
    if ([1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
        .contains(number)) {
      return Colors.red;
    }
    return Colors.black; // Default to black for others
  }

  // Helper widget to build individual number cells
  Widget _buildNumberCell(String numberText, Color color,
      {double width = 60, double height = 60, VoidCallback? onTap}) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(2.0), // Small margin between cells
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0), // Slightly rounded corners
        // Subtle border
      ),
      child: InkWell(
        // Use InkWell for tap feedback, even if no action is implemented
        onTap: onTap,
        child: Center(
          child: Text(
            numberText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build the "2 to 1" cells at the bottom of the columns
  Widget _buildTwoToOneCell({double width = 60, double height = 60}) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.green.shade900,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: const Center(
        child: Text(
          '2 to 1',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  // Helper widget for "dozen" betting areas (e.g., 1st 12)
  Widget _buildDozenBetCell(String text,
      {double width = 240, double height = 60}) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.green.shade900,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  // Helper widget for other outside betting areas (e.g., EVEN, RED)
  Widget _buildOutsideBetCell(String text, Color color,
      {double width = 90, double height = 60}) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildRules({String text = 'Rules', VoidCallback? onTap}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: onTap,
          color: Colors.blue.shade900,
        ),
      ],
    );
  }

  // Widget _buildToggleZero() {
  //   return StatefulBuilder(
  //     builder: (context, setState) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //         child: Row(
  //           children: [
  //             const Text(
  //               'Double 0 layout',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 24,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Switch(
  //               value: doubleZeroEnabled,
  //               onChanged: (bool value) {
  //                 setState(() {
  //                   doubleZeroEnabled = value;
  //                   setState(() {});
  //                 });
  //               },
  //               activeColor: Colors.green.shade900,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // Define consistent cell dimensions for the board for alignment
    const double cellSize = 60.0;
    // Calculate the combined height for the 0 and 00 cells to span 3 rows of numbers
    // 3 cells * cellSize + 2 margins * 2.0 (for top/bottom of each cell)
    const double greenCellCombinedHeight = (cellSize * 3) +
        (2.0 *
            6); // 3 numbers * cell height + 6 margins (3 cells * 2 margins each)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roulette Board Guide',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
      ),
      backgroundColor:
          Colors.green.shade300, // Light green background for the app
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // This main Row holds all the vertical sections of the board
          children: [
            // --- 0 section---
            Column(
              children: [
                // _buildNumberCell('0', _getNumberColor(0),
                //     height: greenCellCombinedHeight),
                if (doubleZeroEnabled) ...[
                  _buildNumberCell('0', _getNumberColor(0),
                      height: greenCellCombinedHeight / 2.1),
                  _buildNumberCell('00', _getNumberColor(37),
                      height: greenCellCombinedHeight / 2.1),
                ] else ...[
                  _buildNumberCell('0', _getNumberColor(0),
                      height: greenCellCombinedHeight),
                ]
              ],
            ),

            // --- Main 1-36 Numbers Grid (3 rows, 12 columns) and "2 to 1" cells ---
            Column(
              children: [
                // Top row of numbers
                Row(
                  children: List.generate(
                    12,
                    (i) => _buildNumberCell(
                        '${(3 * i) + 3}', _getNumberColor((3 * i) + 3),
                        width: cellSize),
                  ),
                ),

                // Middle row of numbers (2, 5, 8, ..., 35)
                Row(
                  children: List.generate(
                      12,
                      (i) => _buildNumberCell(
                          '${(3 * i) + 2}', _getNumberColor((3 * i) + 2),
                          width: cellSize, height: cellSize)),
                ),
                // Bottom row of numbers
                Row(
                  children: List.generate(
                      12,
                      (i) => _buildNumberCell(
                          '${(3 * i) + 1}', _getNumberColor((3 * i) + 1),
                          width: cellSize, height: cellSize)),
                ),

                //! Dozen bets
                Row(
                  children: List.generate(
                    3,
                    (i) => _buildDozenBetCell(
                      '${(i * 12) + 1} - ${(i + 1) * 12}',
                      width: 250,
                    ),
                  ),
                ),

                //! Outside bets
                Row(
                  children: [
                    _buildOutsideBetCell('1-18', Colors.blueGrey.shade800,
                        width: 120, height: cellSize),
                    _buildOutsideBetCell('EVEN', Colors.blueGrey.shade800,
                        width: 120, height: cellSize),
                    _buildOutsideBetCell('RED', Colors.red,
                        width: 120, height: cellSize),
                    _buildOutsideBetCell('BLACK', Colors.black,
                        width: 120, height: cellSize),
                    _buildOutsideBetCell('ODD', Colors.blueGrey.shade800,
                        width: 120, height: cellSize),
                    _buildOutsideBetCell('19-36', Colors.blueGrey.shade800,
                        width: 120, height: cellSize),
                  ],
                ),
                SizedBox(height: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // _buildToggleZero(),
                    _buildRules(
                        text: 'Straight Up 35:1',
                        onTap: () => showDialogForStriaghtUp(context)),
                    _buildRules(
                        text: 'Split 17:1',
                        onTap: () => showDialogForSplitBet(context)),
                    _buildRules(
                        text: 'Street 11:1',
                        onTap: () => showDialogForStreetBet(context)),
                    _buildRules(
                        text: 'Corner 8:1',
                        onTap: () => showDialogForCornerBet(context)),
                    _buildRules(
                        text: 'Double Street or Line 5:1',
                        onTap: () => showDialogForLineBet(context)),
                    _buildRules(
                      text: 'Column & Dozen bets 2:1',
                      onTap: () => showDialogForDozenColumnBet(context),
                    ),
                    _buildRules(
                      text: 'Outside bets 1:1',
                      onTap: () => showDialogForOneToOneOutsideBet(context),
                    ),
                  ],
                ),
              ],
            ),
            // --- Column bets ---
            Column(
              children: [
                _buildTwoToOneCell(height: 60, width: 60),
                _buildTwoToOneCell(height: 60, width: 60),
                _buildTwoToOneCell(height: 60, width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
