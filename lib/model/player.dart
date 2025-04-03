import 'package:chess/model/piece.dart';

class Player {
  PieceColor color;
  late int maxTime;
  Stopwatch timer = Stopwatch();

  Player(time, this.color) {
    maxTime = time * 60;
  }
}
