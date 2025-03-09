import 'package:chess/model/board.dart';
import 'package:chess/riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(riverpodGame);
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemBuilder: _getBoard(),
          itemCount: 8 * 8,
        ),
      ),
    );
  }

  Widget _getBoard(BuildContext context, int index) {
    int x, y = 0;
    x = (index / 8).floor();
    y = (index % 8);
    return GestureDetector(
      onTap: () => _tileClicked(x, y, context),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
            color: ((x + y) % 2 != 0) ? Colors.brown : Colors.white54,
            // border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Center(child: board[x][y]?.image),
        ),
      ),
    );
  }

  void _tileClicked(int x, int y, BuildContext context) {
    setState(() {
      Piece? piece = board[x][y];
      if (piece == null) {
        return;
      }

      if (piece is Marker) {
        piece.movePiece(board);
      } else {
        piece.showMoves(board);
      }
      _clearMarkers();
      // board[x - 1][y] = piece;
      // board[x][y] = null;
    });
    // print(piece?.column);
    // if (piece == null) {
    //   return;
    // }
    // piece.showMoves(board);
  }
}
