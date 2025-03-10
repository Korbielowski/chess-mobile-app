import 'package:chess/model/board.dart';
import 'package:chess/model/piece.dart';
import 'package:chess/riverpod.dart';
import 'package:chess/widgets/circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(riverpodGame).board;
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemBuilder: (context, index) {
            return _getBoard(context, index, board);
          },
          itemCount: 8 * 8,
        ),
      ),
    );
  }

  Widget _getBoard(BuildContext context, int index, Board board) {
    int row, column = 0;
    row = (index / 8).floor();
    column = (index % 8);
    return GestureDetector(
      onTap: () => _tileClicked(context, row, column, board),
      child: GridTile(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ((row + column) % 2 != 0) ? Colors.brown : Colors.white,
                // border: Border.all(color: Colors.black, width: 0.5),
              ),
              // child: Center(child: board.board[row][column].i),
            ),
            CircleWidget(),
          ],
        ),
      ),
    );
  }

  void _tileClicked(BuildContext context, int row, int column, Board board) {
    Piece piece = board.board[row][column];
    print("${piece.row} ${piece.column}");

    if (piece is! NoPiece && piece.showMarker == false) {
      piece.showPossibleMoves(board);
    } else if (piece is! NoPiece && piece.showMarker == true) {
      // piece.movePiece(board, , );
      board.zeroPossibleMoves();
    } else if (piece is NoPiece && piece.showMarker == false) {
      board.zeroPossibleMoves();
    } else if (piece is NoPiece && piece.showMarker == true) {
      // piece.movePiece(board, markerRow, markerColumn)
    }
    // if (piece is Marker) {
    //   piece.movePiece(board);
    // } else {
    //   piece.showMoves(board);
    // }
    // _clearMarkers();
    // board[x - 1][y] = piece;
    // board[x][y] = null;
    // print(piece?.column);
    // if (piece == null) {
    //   return;
    // }
    // piece.showMoves(board);
  }
}
