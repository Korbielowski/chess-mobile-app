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

  Game();
}
