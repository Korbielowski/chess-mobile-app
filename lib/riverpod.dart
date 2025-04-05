import 'package:chess/model/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameProvider = ChangeNotifierProvider((ref) {
  return Game();
});
