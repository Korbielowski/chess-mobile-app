import 'package:chess/model/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final riverpodGame = ChangeNotifierProvider<Game>((ref) {
  return Game();
});
