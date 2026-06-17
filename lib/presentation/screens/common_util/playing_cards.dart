import 'dart:math';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Card model
// ---------------------------------------------------------------------------

enum Suit { spades, hearts, diamonds, clubs }

class PlayingCard {
  final int rank; // 1=Ace, 2-10, 11=J, 12=Q, 13=K
  final Suit suit;

  const PlayingCard(this.rank, this.suit);

  String get rankLabel {
    switch (rank) {
      case 1:
        return 'A';
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      default:
        return rank.toString();
    }
  }

  String get suitSymbol {
    switch (suit) {
      case Suit.spades:
        return '♠';
      case Suit.hearts:
        return '♥';
      case Suit.diamonds:
        return '♦';
      case Suit.clubs:
        return '♣';
    }
  }

  Color get suitColor {
    switch (suit) {
      case Suit.hearts:
      case Suit.diamonds:
        return Colors.red;
      case Suit.spades:
      case Suit.clubs:
        return Colors.black;
    }
  }
}

// ---------------------------------------------------------------------------
// Shoe (Configurable deck count)
// ---------------------------------------------------------------------------

class Shoe {
  final Random _rng = Random();
  final List<PlayingCard> _cards = [];
  final int deckCount;

  Shoe({this.deckCount = 8}) {
    _rebuild();
  }

  void _rebuild() {
    _cards.clear();
    for (int d = 0; d < deckCount; d++) {
      for (final suit in Suit.values) {
        for (int r = 1; r <= 13; r++) {
          _cards.add(PlayingCard(r, suit));
        }
      }
    }
    _cards.shuffle(_rng);
  }

  PlayingCard draw() {
    // If the shoe is getting low, rebuild it. 
    // For standard casino feel, we might rebuild when 10-20% is left, 
    // but keeping the original logic of < 6 cards for now.
    if (_cards.length < 6) _rebuild();
    return _cards.removeLast();
  }

  int get remainingCards => _cards.length;

  void shuffle() => _rebuild();
}