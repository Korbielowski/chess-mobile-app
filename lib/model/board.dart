import 'package:chess/model/piece.dart';

class Board {
  late List<List<Piece>> board;

  Board() {
    board = List.generate(
      8,
      (i) => List.filled(8, NoPiece(-1, -1, PieceColor.noColor)),
    );

    List<List<int>> tmpBoard = [
      [5, 3, 2, 9, 10, 2, 3, 5],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [5, 3, 2, 9, 10, 2, 3, 5],
    ];

    for (int row = 0; row < 8; row++) {
      for (int column = 0; column < 8; column++) {
        int pieceValue = tmpBoard[row][column];

        PieceColor color;
        if (row <= 2) {
          color = PieceColor.black;
        } else if (row >= 6) {
          color = PieceColor.white;
        } else {
          color = PieceColor.noColor;
        }

        if (pieceValue == 0) {
          board[row][column] = NoPiece(row, column, color);
        } else if (pieceValue == 1) {
          board[row][column] = Pawn(row, column, color);
        } else if (pieceValue == 2) {
          board[row][column] = Bishop(row, column, color);
        } else if (pieceValue == 3) {
          board[row][column] = Knight(row, column, color);
        } else if (pieceValue == 5) {
          board[row][column] = Rook(row, column, color);
        } else if (pieceValue == 9) {
          board[row][column] = Queen(row, column, color);
        } else if (pieceValue == 10) {
          board[row][column] = King(row, column, color);
        }
      }
    }
  }
}
