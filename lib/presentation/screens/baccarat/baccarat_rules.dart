import 'package:flutter/material.dart';

/// Baccarat rules reference page.
class BaccaratRulesScreen extends StatelessWidget {
  const BaccaratRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baccarat Rules'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _RuleSectionTitle(title: 'Player Third-Card Rule'),
                const _SimpleRuleTable(columnLabel: 'Player Total'),
                const SizedBox(height: 24),
                _RuleSectionTitle(title: 'Banker Rule (when Player stands)'),
                const _SimpleRuleTable(columnLabel: 'Banker Total'),
                const SizedBox(height: 24),
                _RuleSectionTitle(
                  title: 'Banker Rule (when Player draws a third card)',
                ),
                const _ComplexBankerTable(),
                const SizedBox(height: 24),
                const _NotesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RuleSectionTitle extends StatelessWidget {
  final String title;
  const _RuleSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _SimpleRuleTable extends StatelessWidget {
  final String columnLabel;
  const _SimpleRuleTable({required this.columnLabel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DataTable(
        columns: [
          DataColumn(label: Text(columnLabel)),
          const DataColumn(label: Text('Action')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('0 - 5')),
            DataCell(Text('Draw third card')),
          ]),
          DataRow(cells: [
            DataCell(Text('6 - 7')),
            DataCell(Text('Stand')),
          ]),
          DataRow(cells: [
            DataCell(Text('8 - 9')),
            DataCell(Text('Natural — Stand')),
          ]),
        ],
      ),
    );
  }
}

class _ComplexBankerTable extends StatelessWidget {
  const _ComplexBankerTable();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Banker')),
            DataColumn(label: Text('Draws if Player 3rd card is:')),
          ],
          rows: const [
            DataRow(cells: [DataCell(Text('0, 1, 2')), DataCell(Text('Always'))]),
            DataRow(cells: [DataCell(Text('3')), DataCell(Text('Anything but 8'))]),
            DataRow(cells: [DataCell(Text('4')), DataCell(Text('2 – 7'))]),
            DataRow(cells: [DataCell(Text('5')), DataCell(Text('4 – 7'))]),
            DataRow(cells: [DataCell(Text('6')), DataCell(Text('6 – 7'))]),
            DataRow(cells: [DataCell(Text('7')), DataCell(Text('Stand'))]),
          ],
        ),
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Text(
                  'Notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                 SizedBox(height: 8),
                 Text(
                  'These are the standard baccarat third-card rules applied in this app. ' 
                  'Naturals (8 or 9) end the round immediately.',
                  style: TextStyle(fontSize: 14),
                ),
          ],
        ),
      ),
    );
  }
}
