import 'package:flutter/material.dart';

// --- Shared color constants ---
const kBackgroundDark = Color(0xFF1a1a1a);
const kCardDark = Color(0xFF2d2d2d);
const kBoardGreen = Color(0xFF0d5c0d);
const kBetGreen = Color(0xFF1a5c1a);

// --- Payout data: betSize -> (ratio, description) ---
const kPayoutData = <int, (int, String)>{
  1: (35, 'Straight Up'),
  2: (17, 'Split'),
  3: (11, 'Street'),
  4: (8, 'Corner'),
  6: (5, 'Double Street'),
  12: (2, 'Dozen'),
  18: (1, 'Even Money'),
};

// --- Grid layout constants ---
const kRowCount = 3;
const kColCount = 12;
const kCellHeight = 50.0;
const kGap = 4.0;
const kGridHeight = kCellHeight * kRowCount + kGap * (kRowCount - 1);

// Roulette numbers with their colors
const Map<int, String> numberColors = {
  0: 'green',
  1: 'red',
  2: 'black',
  3: 'red',
  4: 'black',
  5: 'red',
  6: 'black',
  7: 'red',
  8: 'black',
  9: 'red',
  10: 'black',
  11: 'black',
  12: 'red',
  13: 'black',
  14: 'red',
  15: 'black',
  16: 'red',
  17: 'black',
  18: 'red',
  19: 'red',
  20: 'black',
  21: 'red',
  22: 'black',
  23: 'red',
  24: 'black',
  25: 'red',
  26: 'black',
  27: 'red',
  28: 'black',
  29: 'black',
  30: 'red',
  31: 'black',
  32: 'red',
  33: 'black',
  34: 'red',
  35: 'black',
  36: 'red',
};

// Board layout
const List<List<int>> boardLayout = [
  [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36],
  [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35],
  [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34],
];
