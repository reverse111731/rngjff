import 'package:flutter/material.dart';

class DateCalculatorScreen extends StatefulWidget {
  const DateCalculatorScreen({super.key});

  @override
  State<DateCalculatorScreen> createState() => _DateCalculatorScreenState();
}

class _DateCalculatorScreenState extends State<DateCalculatorScreen> {
  DateTime _futureDate = DateTime.now();
  String _result = '';

  Future<void> _pickFutureDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _futureDate.isAfter(now) ? _futureDate : now,
      firstDate: now,
      lastDate: DateTime(2100),
      helpText: 'Select a future date',
    );

    if (picked != null) {
      setState(() {
        _futureDate = picked;
        _result = _calculateDifference(now, picked);
      });
    }
  }

  String _calculateDifference(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    final totalDays = toDate.difference(fromDate).inDays;

    if (totalDays == 0) return 'The selected date is today!';

    final years = totalDays ~/ 365;
    final remainingAfterYears = totalDays % 365;
    final months = remainingAfterYears ~/ 30;
    final days = remainingAfterYears % 30;
    final weeks = totalDays ~/ 7;

    final parts = <String>[];
    if (years > 0) parts.add('$years ${years == 1 ? 'year' : 'years'}');
    if (months > 0) parts.add('$months ${months == 1 ? 'month' : 'months'}');
    if (days > 0) parts.add('$days ${days == 1 ? 'day' : 'days'}');

    final readable = parts.join(', ');

    return '$readable\n($totalDays total days · $weeks weeks)';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Calculator'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Today's date card
              _DateCard(
                label: "Today's Date",
                date: now,
                icon: Icons.today,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 16),
              const Icon(Icons.arrow_downward, size: 32, color: Colors.grey),
              const SizedBox(height: 16),

              // Future date card (tappable)
              GestureDetector(
                onTap: _pickFutureDate,
                child: _DateCard(
                  label: 'Future Date',
                  date: _result.isEmpty ? null : _futureDate,
                  icon: Icons.event,
                  color: Colors.deepPurple,
                  placeholder: 'Tap to select a date',
                ),
              ),

              const SizedBox(height: 32),

              // Result
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _result.isEmpty
                    ? Text(
                        'Pick a future date to see the difference',
                        key: const ValueKey('hint'),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Container(
                        key: const ValueKey('result'),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.deepPurple.shade200,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Time Until',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _result,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Pick date button
              FilledButton.icon(
                onPressed: _pickFutureDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  _result.isEmpty ? 'Select Future Date' : 'Change Date',
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final String label;
  final DateTime? date;
  final IconData icon;
  final Color color;
  final String? placeholder;

  const _DateCard({
    required this.label,
    required this.date,
    required this.icon,
    required this.color,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final displayDate = date != null
        ? '${_monthName(date!.month)} ${date!.day}, ${date!.year}'
        : (placeholder ?? '—');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                displayDate,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: date != null ? Colors.black87 : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
