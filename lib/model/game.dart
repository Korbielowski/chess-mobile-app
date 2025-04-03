import 'package:chess/model/board.dart';
import 'package:chess/model/piece.dart';
import 'package:chess/model/player.dart';
import 'package:flutter/material.dart';

class Game extends ChangeNotifier {
  Board board = Board();
  List<Player> players = [
    Player(10, PieceColor.white),
    Player(10, PieceColor.black),
  ];
  late Player currentPlayer;
  Game() {
    currentPlayer = players[0];
    currentPlayer.timer.start();
  }

  void switchPlayer() {
    currentPlayer.timer.stop();
    if (currentPlayer.color == PieceColor.white) {
      currentPlayer = players[1];
    } else {
      currentPlayer = players[0];
    }
    currentPlayer.timer.start();
  }

  void endGame() {
    players[0].timer.stop();
    players[1].timer.stop();
  }
}
