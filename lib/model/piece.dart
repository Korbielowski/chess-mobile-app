import 'package:chess/model/board.dart';
import 'package:flutter/cupertino.dart';

enum PieceColor { black, white, noColor }

abstract class Piece {
  late PieceColor color;
  late int column;
  late int row;
  late Image image;
  bool showMarker = false;

  Piece(this.row, this.column, this.color);
  void showPossibleMoves(Board board);
  void movePiece(
    List<List<Piece>> board,
    Piece piece,
    int destinationRow,
    int destinationColumn,
  ) {
    board[piece.row][piece.column] = NoPiece(
      piece.row,
      piece.column,
      PieceColor.noColor,
    );
    if (board[destinationRow][destinationColumn] is! NoPiece) {
      board[destinationRow][destinationColumn] = NoPiece(
        destinationRow,
        destinationColumn,
        PieceColor.noColor,
      );
    }
    piece.updateMe(destinationRow, destinationColumn);
    board[destinationRow][destinationColumn] = piece;
  }

  void updateMe(int destinationRow, int destinationColumn);
  void destroyPiece(Board board);
}

class NoPiece extends Piece {
  NoPiece(super.row, super.column, super.color);

  @override
  void showPossibleMoves(Board board) {}

  @override
  void updateMe(int destinationRow, int destinationColumn) {}

  @override
  void destroyPiece(Board board) {}
}

class Pawn extends Piece {
  bool isFirstMove = true;
  bool isEnPassant = false;

  Pawn(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/white_pawn.png");
    } else {
      image = Image.asset("assets/pieces/black_pawn.png");
    }
  }

  @override
  void showPossibleMoves(Board board) {
    if (color == PieceColor.white) {
      // First move by two rows
      if (isFirstMove && board.board[row - 2][column] is NoPiece) {
        board.board[row - 2][column].showMarker = true;
      }

      // Normal move by one row
      if (row - 1 >= 0 && board.board[row - 1][column] is NoPiece) {
        board.board[row - 1][column].showMarker = true;
      }

      // Attack right
      if (column + 1 <= 7 &&
          board.board[row - 1][column + 1] is! NoPiece &&
          board.board[row - 1][column + 1].color != color) {
        board.board[row - 1][column + 1].showMarker = true;
      }

      // Attack left
      if (column - 1 >= 0 &&
          board.board[row - 1][column - 1] is! NoPiece &&
          board.board[row - 1][column - 1].color != color) {
        board.board[row - 1][column - 1].showMarker = true;
      }
    } else {
      if (isFirstMove && board.board[row + 2][column] is NoPiece) {
        board.board[row + 2][column].showMarker = true;
      }

      if (board.board[row + 1][column] is NoPiece) {
        board.board[row + 1][column].showMarker = true;
      }

      if (column + 1 <= 7 &&
          board.board[row + 1][column + 1] is! NoPiece &&
          board.board[row + 1][column + 1].color != color) {
        board.board[row + 1][column + 1].showMarker = true;
      }

      if (column - 1 >= 0 &&
          board.board[row + 1][column - 1] is! NoPiece &&
          board.board[row + 1][column - 1].color != color) {
        board.board[row + 1][column - 1].showMarker = true;
      }
    }
  }

  @override
  updateMe(destinationRow, destinationColumn) {
    if (isFirstMove == true) {
      isFirstMove = false;
    }
    row = destinationRow;
    column = destinationColumn;
  }

  @override
  void destroyPiece(Board board) {}
}

class Knight extends Piece {
  Knight(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/white_knight.png");
    } else {
      image = Image.asset("assets/pieces/black_knight.png");
    }
  }

  @override
  void showPossibleMoves(Board board) {}

  @override
  void updateMe(int destinationRow, int destinationColumn) {}

  @override
  void destroyPiece(Board board) {}
}

class Bishop extends Piece {
  Bishop(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/white_bishop.png");
    } else {
      image = Image.asset("assets/pieces/black_bishop.png");
    }
  }

  @override
  void showPossibleMoves(Board board) {}

  @override
  void updateMe(int destinationRow, int destinationColumn) {}

  @override
  void destroyPiece(Board board) {}
}

class Rook extends Piece {
  Rook(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/white_rook.png");
    } else {
      image = Image.asset("assets/pieces/black_rook.png");
    }
  }

  @override
  void showPossibleMoves(Board board) {}

  @override
  void updateMe(int destinationRow, int destinationColumn) {}

  @override
  void destroyPiece(Board board) {}
}

class Queen extends Piece {
  Queen(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/white_queen.png");
    } else {
      image = Image.asset("assets/pieces/black_queen.png");
    }
  }

  @override
  void showPossibleMoves(Board board) {}

  @override
  void updateMe(int destinationRow, int destinationColumn) {}

  @override
  void destroyPiece(Board board) {}
}

class King extends Piece {
  King(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/white_king.png");
    } else {
      image = Image.asset("assets/pieces/black_king.png");
    }
  }

  @override
  void showPossibleMoves(Board board) {}

  @override
  void updateMe(int destinationRow, int destinationColumn) {}

  @override
  void destroyPiece(Board board) {}
}
