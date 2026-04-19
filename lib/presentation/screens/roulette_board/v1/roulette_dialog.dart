import 'package:flutter/material.dart';

void showDialogForStriaghtUp(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Straight Up Bet Info'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'A "Straight Up" bet in roulette is a wager placed on a single specific number on the roulette table.',
              ),
              SizedBox(height: 8),
              Text('How it works:'),
              Text('- Place your chip directly on any single number (0-36).'),
              Text('- If the ball lands on your chosen number, you win.'),
              Text('- The payout for a straight up bet is 35 to 1.'),
              SizedBox(height: 8),
              Text(
                  'Straight up bets have the highest payout but the lowest probability of winning.'),
              SizedBox(height: 8),
              Text(
                  'Disclaimer: Roulette is a game of chance and all bets involve risk.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got It'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogForSplitBet(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Split Bet Info'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'A "Split" bet in roulette is a wager placed on two adjacent numbers on the roulette table.',
              ),
              SizedBox(height: 8),
              Text('How it works:'),
              Text(
                  '- Place your chip on the line between any two adjacent numbers (either vertically or horizontally).'),
              Text(
                  '- If the ball lands on either of your chosen numbers, you win.'),
              Text('- The payout for a split bet is 17 to 1.'),
              SizedBox(height: 8),
              Text(
                  'Split bets offer a higher chance of winning than straight up bets, but with a lower payout.'),
              SizedBox(height: 8),
              Text(
                  'Disclaimer: Roulette is a game of chance and all bets involve risk.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got It'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogForCornerBet(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Corner Bet Info'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'A "Corner" bet in roulette is a wager placed on four numbers that meet at one corner on the roulette table.',
              ),
              SizedBox(height: 8),
              Text('How it works:'),
              Text(
                  '- Place your chip at the intersection where four numbers touch.'),
              Text(
                  '- If the ball lands on any of those four numbers, you win.'),
              Text('- The payout for a corner bet is 8 to 1.'),
              SizedBox(height: 8),
              Text(
                  'Corner bets offer a higher chance of winning than straight up or split bets, but with a lower payout.'),
              SizedBox(height: 8),
              Text(
                  'Disclaimer: Roulette is a game of chance and all bets involve risk.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got It'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogForStreetBet(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Street Bet Info'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'A "Street" bet in roulette is a wager placed on three consecutive numbers in a horizontal line on the roulette table.',
              ),
              SizedBox(height: 8),
              Text('How it works:'),
              Text(
                  '- Place your chip on the outer edge of the row you want to bet on (covering three numbers in that row).'),
              Text(
                  '- If the ball lands on any of those three numbers, you win.'),
              Text('- The payout for a street bet is 11 to 1.'),
              SizedBox(height: 8),
              Text(
                  'Street bets offer a higher chance of winning than straight up or split bets, but with a lower payout.'),
              SizedBox(height: 8),
              Text(
                  'Disclaimer: Roulette is a game of chance and all bets involve risk.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got It'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogForLineBet(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Line Bet Info'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'A "Line" bet in roulette, also known as a "Six Line" bet, is a wager placed on six consecutive numbers that form two adjacent rows on the roulette table.',
              ),
              SizedBox(height: 8),
              Text('How it works:'),
              Text(
                  '- Place your chip at the intersection on the outer edge where two rows meet.'),
              Text('- If the ball lands on any of those six numbers, you win.'),
              Text('- The payout for a line bet is 5 to 1.'),
              SizedBox(height: 8),
              Text(
                  'Line bets offer a higher chance of winning than street, split, or straight up bets, but with a lower payout.'),
              SizedBox(height: 8),
              Text(
                  'Disclaimer: Roulette is a game of chance and all bets involve risk.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got It'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogForDozenColumnBet(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Dozen/Column Bet Info'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'A "Dozen" or "Column" bet in roulette is a wager placed on one of the three dozens (1-12, 13-24, 25-36) or one of the three vertical columns of numbers on the table.',
              ),
              SizedBox(height: 8),
              Text('How it works:'),
              Text(
                  '- Place your chip in the area marked for 1st 12, 2nd 12, 3rd 12, or at the bottom of a column.'),
              Text(
                  '- If the ball lands on a number within your chosen dozen or column, you win.'),
              Text(
                  '- The payout for these bets is 2 to 1 (you win twice your bet amount).'),
              SizedBox(height: 8),
              Text(
                  'Dozen and column bets cover 12 numbers each, offering a higher chance of winning than inside bets, but with a lower payout.'),
              SizedBox(height: 8),
              Text(
                  'Disclaimer: Roulette is a game of chance and all bets involve risk.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got It'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogForOneToOneOutsideBet(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('1 to 1 Outside Bet Info'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'A "1 to 1 Outside Bet" in roulette refers to bets placed on larger groups of numbers, such as Red/Black, Odd/Even, or 1-18/19-36.',
              ),
              SizedBox(height: 8),
              Text('How it works:'),
              Text(
                  '- Place your chip in the area for Red, Black, Odd, Even, 1-18, or 19-36.'),
              Text(
                  '- If the ball lands on a number within your chosen group, you win.'),
              Text(
                  '- The payout for these bets is 1 to 1 (you win the same amount as your bet).'),
              SizedBox(height: 8),
              Text(
                  '1 to 1 outside bets have nearly a 50% chance of winning, but the payout is lower compared to inside bets.'),
              SizedBox(height: 8),
              Text(
                  'Disclaimer: Roulette is a game of chance and all bets involve risk.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got It'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
