// import 'package:chess/model/board.dart';
import 'package:chess/model/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final boardProvider = ChangeNotifierProvider((ref) {
  return Game().board;
});

// final riverpodBoard = ChangeNotifierProvider<Board>((ref) {
//   return Board();
// });
