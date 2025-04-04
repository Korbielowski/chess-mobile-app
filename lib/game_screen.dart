import 'package:chess/model/game.dart';
import 'package:chess/model/piece.dart';
import 'package:chess/riverpod.dart';
import 'package:chess/widgets/circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemBuilder: (context, index) {
            return _getBoard(context, index, game);
          },
          itemCount: 8 * 8,
        ),
      ),
    );
  }

  Widget _getBoard(BuildContext context, int index, Game game) {
    int row, column = 0;
    row = (index / 8).floor();
    column = (index % 8);
    return GestureDetector(
      onTap: () => game.tileClicked(context, row, column),
      child: GridTile(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ((row + column) % 2 != 0) ? Colors.brown : Colors.white,
                // border: Border.all(color: Colors.black, width: 0.5),
              ),
              child:
                  (game.board.board[row][column] is! NoPiece)
                      ? Center(child: game.board.board[row][column].image)
                      : null,
            ),
            CircleWidget(row, column),
          ],
        ),
      ),
    );
  }
}
