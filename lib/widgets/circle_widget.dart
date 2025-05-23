import 'package:chess/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CircleWidget extends ConsumerWidget {
  final int row;
  final int column;
  const CircleWidget(this.row, this.column, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    return Offstage(
      offstage:
          (game.board.board[row][column].showMarker == true) ? false : true,
      child: Opacity(
        opacity: 0.35,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
