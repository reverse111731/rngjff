import 'package:flutter/material.dart';
import 'constant_roulette_board.dart';

class RouletteV2 extends StatelessWidget {
  const RouletteV2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roulette Board Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: kBackgroundDark,
        useMaterial3: true,
      ),
      home: const RouletteBoard(),
    );
  }
}

class RouletteBoard extends StatefulWidget {
  const RouletteBoard({super.key});

  @override
  State<RouletteBoard> createState() => _RouletteBoardState();
}

class _RouletteBoardState extends State<RouletteBoard> {
  // Track selected numbers (hits)
  final Set<int> selectedNumbers = {};

  // Bet tracking
  final Set<int> currentBet = {};

  // Toggle a single number in / out of the current bet
  void _toggleNumber(int number) {
    setState(() {
      currentBet.contains(number)
          ? currentBet.remove(number)
          : currentBet.add(number);
    });
  }

  void _resetAll() {
    setState(() {
      selectedNumbers.clear();
      currentBet.clear();
    });
  }

  // Unified handler for street / corner / double-street / split bets
  void _toggleBetGroup(List<int> numbers) {
    setState(() {
      numbers.every(currentBet.contains)
          ? currentBet.removeAll(numbers)
          : currentBet.addAll(numbers);
    });
  }

  // Calculate coverage percentage
  double get coveragePercentage =>
      currentBet.isEmpty ? 0.0 : (currentBet.length / 37) * 100;

  // Calculate uncovered percentage (opposite of coverage)
  String get uncoveredPercentage => currentBet.isEmpty
      ? '0.0%'
      : '-${(100 - coveragePercentage).toStringAsFixed(1)}%';

  // Calculate payout ratio based on bet size
  int get payoutRatio => kPayoutData[currentBet.length]?.$1 ?? 0;

  // Get payout description
  String get payoutDescription {
    if (currentBet.isEmpty) return 'No bet';
    return kPayoutData[currentBet.length]?.$2 ?? 'Custom Bet';
  }

  Color _numberColor(int number) {
    final color = numberColors[number] ?? 'black';
    return switch (color) {
      'red' => Colors.red.shade700,
      'green' => Colors.green.shade700,
      _ => Colors.black87,
    };
  }

  // Grid cell width depends on available space
  double _cellWidth(double gridWidth) =>
      (gridWidth - kGap * (kColCount - 1)) / kColCount;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(
                  'Roulette Board Analyzer',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: kCardDark,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Statistics Panel
                      _buildStatisticsPanel(),
                      const SizedBox(height: 20),

                      // Roulette Board
                      _buildRouletteBoard(),
                      const SizedBox(height: 20),

                      _clearButton(),
                      const SizedBox(height: 20),

                      // Win/Loss Section
                      _buildWinLossSection(),
                    ],
                  ),
                ),
              ),
            ),

            // Portrait mode overlay — prompt user to rotate
            if (orientation == Orientation.portrait)
              Container(
                color: Colors.black.withOpacity(0.9),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.screen_rotation,
                        color: Colors.white,
                        size: 64,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Please rotate your device',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'This screen is best viewed in landscape mode',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatisticsPanel() {
    return Card(
      color: kCardDark,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bet Statistics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Numbers Selected',
                  '${currentBet.length}',
                  Colors.blue,
                ),
                _buildStatItem(
                  'Coverage',
                  '${coveragePercentage.toStringAsFixed(1)}%',
                  Colors.green.shade300,
                ),
                _buildStatItem(
                  'Uncovered',
                  uncoveredPercentage,
                  Colors.red.shade300,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildRouletteBoard() {
    return Card(
      color: kBoardGreen,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Main board with 0 on the left
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Zero on the left side
                SizedBox(
                  width: 60,
                  child: SizedBox(
                    height: kGridHeight,
                    child: _buildNumberButton(0),
                  ),
                ),
                const SizedBox(width: 4),
                // Main number grid with betting spots
                Expanded(child: _buildMainNumberGrid()),
              ],
            ),

            const SizedBox(height: 8),

            // Outside bets
            _buildOutsideBetsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainNumberGrid() {
    return Column(
      children: [
        // Base number grid with corner bets overlaid
        SizedBox(
          height: kGridHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Base number grid
                  Column(
                    children: boardLayout
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  entry.key < boardLayout.length - 1 ? 4.0 : 0,
                            ),
                            child: Row(
                              children: entry.value.map((number) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: _buildNumberButton(number),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  // Corner bets overlay
                  _buildCornerBetsOverlay(constraints.maxWidth),
                  // Split bets overlay
                  _buildSplitBetsOverlay(constraints.maxWidth),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        // Street and double street bets below the grid
        _buildStreetBetsRow(),
      ],
    );
  }

  Widget _buildStreetBetsRow() {
    return Row(
      children: List.generate(12, (colIndex) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: colIndex < 11 ? 4.0 : 0),
            child: Row(
              children: [
                // Double street bet (between columns)
                if (colIndex > 0)
                  Flexible(flex: 0, child: _buildDoubleStreetBet(colIndex - 1)),
                if (colIndex > 0) const SizedBox(width: 2),
                // Street bet (below column)
                Expanded(child: _buildStreetBet(colIndex)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCornerBetsOverlay(double gridWidth) {
    final cw = _cellWidth(gridWidth);

    // Generate corner bets for all intersections
    return Stack(
      children: [
        for (int row = 0; row < kRowCount - 1; row++)
          for (int col = 0; col < kColCount - 1; col++)
            Positioned(
              left: (col + 1) * (cw + kGap) - 8,
              top: (row + 1) * (kCellHeight + kGap) - 8,
              child: _buildCornerBet(row, col),
            ),
      ],
    );
  }

  Widget _buildSplitBetsOverlay(double gridWidth) {
    final cw = _cellWidth(gridWidth);

    return Stack(
      children: [
        // Horizontal split bets (between columns)
        for (int row = 0; row < kRowCount; row++)
          for (int col = 0; col < kColCount - 1; col++)
            Positioned(
              left: (col + 1) * (cw + kGap) - 6,
              top: row * (kCellHeight + kGap) + 17,
              child: _buildHorizontalSplit(row, col),
            ),
        // Vertical split bets (between rows)
        for (int row = 0; row < kRowCount - 1; row++)
          for (int col = 0; col < kColCount; col++)
            Positioned(
              left: col * (cw + kGap) + cw / 2 - 6,
              top: (row + 1) * (kCellHeight + kGap) - 6,
              child: _buildVerticalSplit(row, col),
            ),
      ],
    );
  }

  Widget _buildHorizontalSplit(int rowIndex, int colIndex) {
    // Get the 2 numbers in this horizontal split
    List<int> splitNumbers = [
      boardLayout[rowIndex][colIndex],
      boardLayout[rowIndex][colIndex + 1],
    ];

    bool isSelected = splitNumbers.every((n) => currentBet.contains(n));
    bool hasAny = splitNumbers.any((n) => currentBet.contains(n));

    return GestureDetector(
      onTap: () => _toggleBetGroup(splitNumbers),
      child: Container(
        width: 12,
        height: 16,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.yellow.withOpacity(0.5)
              : (hasAny
                  ? Colors.orange.withOpacity(0.25)
                  : Colors.white.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: isSelected
                ? Colors.yellow
                : (hasAny ? Colors.orange : Colors.grey),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Container(
            width: 2,
            height: 8,
            color: isSelected ? Colors.yellow : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalSplit(int rowIndex, int colIndex) {
    // Get the 2 numbers in this vertical split
    List<int> splitNumbers = [
      boardLayout[rowIndex][colIndex],
      boardLayout[rowIndex + 1][colIndex],
    ];

    bool isSelected = splitNumbers.every((n) => currentBet.contains(n));
    bool hasAny = splitNumbers.any((n) => currentBet.contains(n));

    return GestureDetector(
      onTap: () => _toggleBetGroup(splitNumbers),
      child: Container(
        width: 16,
        height: 12,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.yellow.withOpacity(0.5)
              : (hasAny
                  ? Colors.orange.withOpacity(0.25)
                  : Colors.white.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: isSelected
                ? Colors.yellow
                : (hasAny ? Colors.orange : Colors.grey),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 2,
            color: isSelected ? Colors.yellow : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildStreetBet(int colIndex) {
    // Get the 3 numbers in this column (street)
    List<int> streetNumbers = [
      boardLayout[0][colIndex], // Top
      boardLayout[1][colIndex], // Middle
      boardLayout[2][colIndex], // Bottom
    ];

    bool isSelected = streetNumbers.every((n) => currentBet.contains(n));
    bool hasAny = streetNumbers.any((n) => currentBet.contains(n));

    return GestureDetector(
      onTap: () => _toggleBetGroup(streetNumbers),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.yellow.withOpacity(0.3)
              : (hasAny ? Colors.orange.withOpacity(0.2) : Colors.transparent),
          border: Border.all(
            color: isSelected
                ? Colors.yellow
                : (hasAny ? Colors.orange.withOpacity(0.5) : Colors.grey),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(
            Icons.more_vert,
            color: isSelected ? Colors.yellow : Colors.grey,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCornerBet(int rowIndex, int colIndex) {
    // Get the 4 numbers in this corner
    List<int> cornerNumbers = [
      boardLayout[rowIndex][colIndex],
      boardLayout[rowIndex][colIndex + 1],
      boardLayout[rowIndex + 1][colIndex],
      boardLayout[rowIndex + 1][colIndex + 1],
    ];

    bool isSelected = cornerNumbers.every((n) => currentBet.contains(n));
    bool hasAny = cornerNumbers.any((n) => currentBet.contains(n));

    return GestureDetector(
      onTap: () => _toggleBetGroup(cornerNumbers),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.yellow.withOpacity(0.6)
              : (hasAny
                  ? Colors.orange.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1)),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Colors.yellow
                : (hasAny ? Colors.orange : Colors.grey),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: isSelected ? Colors.yellow : Colors.grey,
            size: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildDoubleStreetBet(int colIndex) {
    // Get the 6 numbers in this double street (two adjacent columns)
    List<int> doubleStreetNumbers = [
      boardLayout[0][colIndex], // Left column top
      boardLayout[1][colIndex], // Left column middle
      boardLayout[2][colIndex], // Left column bottom
      boardLayout[0][colIndex + 1], // Right column top
      boardLayout[1][colIndex + 1], // Right column middle
      boardLayout[2][colIndex + 1], // Right column bottom
    ];

    bool isSelected = doubleStreetNumbers.every((n) => currentBet.contains(n));
    bool hasAny = doubleStreetNumbers.any((n) => currentBet.contains(n));

    return GestureDetector(
      onTap: () => _toggleBetGroup(doubleStreetNumbers),
      child: Container(
        width: 16,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.yellow.withOpacity(0.4)
              : (hasAny ? Colors.orange.withOpacity(0.2) : Colors.transparent),
          border: Border.all(
            color: isSelected
                ? Colors.yellow
                : (hasAny ? Colors.orange.withOpacity(0.5) : Colors.grey),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(
            Icons.more_vert,
            color: isSelected ? Colors.yellow : Colors.grey,
            size: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(int number) {
    bool isBet = currentBet.contains(number);
    bool isHit = selectedNumbers.contains(number);

    return InkWell(
      onTap: () => _toggleNumber(number),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: _numberColor(number),
          border: Border.all(
            color: isBet ? Colors.yellow : Colors.grey,
            width: isBet ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isHit)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutsideBetsSection() {
    // Dozen bets
    final dozens = List.generate(3, (i) {
      final start = i * 12 + 1;
      return List.generate(12, (j) => start + j);
    });

    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: _buildOutsideBet(
                  ['1st 12', '2nd 12', '3rd 12'][i],
                  dozens[i],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _buildOutsideBet('1-18', List.generate(18, (i) => i + 1)),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildOutsideBet(
                'EVEN',
                List.generate(18, (i) => (i + 1) * 2),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildOutsideBet(
                'ODD',
                List.generate(18, (i) => i * 2 + 1),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildOutsideBet(
                '19-36',
                List.generate(18, (i) => i + 19),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOutsideBet(String label, List<int> numbers) {
    final isSelected = numbers.every(currentBet.contains);
    final hasAny = numbers.any(currentBet.contains);

    return InkWell(
      onTap: () => _toggleBetGroup(numbers),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: kBetGreen,
          border: Border.all(
            color: isSelected
                ? Colors.yellow
                : (hasAny ? Colors.orange : Colors.grey),
            width: isSelected ? 3 : (hasAny ? 2 : 1),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _clearButton() {
    return ElevatedButton.icon(
      onPressed: _resetAll,
      icon: const Icon(Icons.clear),
      label: const Text('Clear Bet'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildWinLossSection() {
    return Card(
      color: kCardDark,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payout Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (currentBet.isEmpty)
              Center(
                child: Text(
                  'Select numbers to see payout',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              )
            else if (payoutRatio == 0)
              Center(
                child: Column(
                  children: [
                    Text(
                      'Custom Bet (${currentBet.length} numbers)',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No standard payout for this combination',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  // Bet type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        payoutDescription,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Payout ratio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$payoutRatio:1',
                            style: TextStyle(
                              color: Colors.green.shade300,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Payout Ratio',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  // Win/Loss breakdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '+\$$payoutRatio',
                            style: TextStyle(
                              color: Colors.green.shade300,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Win',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '(Per \$1 bet)',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey.shade700,
                      ),
                      Column(
                        children: [
                          Text(
                            '-\$1',
                            style: TextStyle(
                              color: Colors.red.shade300,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Loss',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '(Per \$1 bet)',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
