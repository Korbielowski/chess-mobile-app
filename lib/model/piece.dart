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

  void updateMe(int destinationRow, int destinationColumn) {
    row = destinationRow;
    column = destinationColumn;
  }

  // void destroyPiece(Board board);
}

class NoPiece extends Piece {
  NoPiece(super.row, super.column, super.color);

  @override
  void showPossibleMoves(Board board) {}

  @override
  void updateMe(int destinationRow, int destinationColumn) {}

  // @override
  // void destroyPiece(Board board) {}
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
    // Determine whether to move up or down, determined by color of a piece
    int upDown = (color == PieceColor.white) ? -1 : 1;

    // First move, able to move by two rows
    if (isFirstMove && board.board[row + 2 * upDown][column] is NoPiece) {
      board.board[row + 2 * upDown][column].showMarker = true;
    }

    // Normal move by one row
    if (row + upDown >= 0 && board.board[row + upDown][column] is NoPiece) {
      board.board[row + upDown][column].showMarker = true;
    }

    // Attack right
    if (column + 1 <= 7 &&
        board.board[row + upDown][column + 1] is! NoPiece &&
        !isKing(board.board[row + upDown][column + 1]) &&
        board.board[row + upDown][column + 1].color != color) {
      board.board[row + upDown][column + 1].showMarker = true;
    }

    // Attack left
    if (column - 1 >= 0 &&
        board.board[row + upDown][column - 1] is! NoPiece &&
        !isKing(board.board[row + upDown][column - 1]) &&
        board.board[row + upDown][column - 1].color != color) {
      board.board[row + upDown][column - 1].showMarker = true;
    }
  }

  @override
  updateMe(destinationRow, destinationColumn) {
    super.updateMe(destinationRow, destinationColumn);
    if (isFirstMove == true) {
      isFirstMove = false;
    }
  }

  // @override
  // void destroyPiece(Board board) {}
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
  void showPossibleMoves(Board board) {
    if (withinBounds(row + 2, column + 1) &&
        (board.board[row + 2][column + 1] is NoPiece ||
            (board.board[row + 2][column + 1] is! NoPiece &&
                !isKing(board.board[row + 2][column + 1]) &&
                board.board[row + 2][column + 1].color != color))) {
      board.board[row + 2][column + 1].showMarker = true;
    }

    if (withinBounds(row + 2, column - 1) &&
        (board.board[row + 2][column - 1] is NoPiece ||
            (board.board[row + 2][column - 1] is! NoPiece &&
                !isKing(board.board[row + 2][column - 1]) &&
                board.board[row + 2][column - 1].color != color))) {
      board.board[row + 2][column - 1].showMarker = true;
    }

    if (withinBounds(row + 1, column + 2) &&
        (board.board[row + 1][column + 2] is NoPiece ||
            (board.board[row + 1][column + 2] is! NoPiece &&
                !isKing(board.board[row + 1][column + 2]) &&
                board.board[row + 1][column + 2].color != color))) {
      board.board[row + 1][column + 2].showMarker = true;
    }

    if (withinBounds(row - 1, column + 2) &&
        (board.board[row - 1][column + 2] is NoPiece ||
            (board.board[row - 1][column + 2] is! NoPiece &&
                !isKing(board.board[row - 1][column + 2]) &&
                board.board[row - 1][column + 2].color != color))) {
      board.board[row - 1][column + 2].showMarker = true;
    }

    if (withinBounds(row - 2, column + 1) &&
        (board.board[row - 2][column + 1] is NoPiece ||
            (board.board[row - 2][column + 1] is! NoPiece &&
                !isKing(board.board[row - 2][column + 1]) &&
                board.board[row - 2][column + 1].color != color))) {
      board.board[row - 2][column + 1].showMarker = true;
    }

    if (withinBounds(row - 2, column - 1) &&
        (board.board[row - 2][column - 1] is NoPiece ||
            (board.board[row - 2][column - 1] is! NoPiece &&
                !isKing(board.board[row - 2][column - 1]) &&
                board.board[row - 2][column - 1].color != color))) {
      board.board[row - 2][column - 1].showMarker = true;
    }

    if (withinBounds(row - 1, column - 2) &&
        (board.board[row - 1][column - 2] is NoPiece ||
            (board.board[row - 1][column - 2] is! NoPiece &&
                !isKing(board.board[row - 1][column - 2]) &&
                board.board[row - 1][column - 2].color != color))) {
      board.board[row - 1][column - 2].showMarker = true;
    }

    if (withinBounds(row + 1, column - 2) &&
        (board.board[row + 1][column - 2] is NoPiece ||
            (board.board[row + 1][column - 2] is! NoPiece &&
                !isKing(board.board[row + 1][column - 2]) &&
                board.board[row + 1][column - 2].color != color))) {
      board.board[row + 1][column - 2].showMarker = true;
    }
  }

  // @override
  // void destroyPiece(Board board) {}
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
  void showPossibleMoves(Board board) {
    int tColumn = column + 1;
    int tRow = row + 1;

    while (withinBounds(tRow, tColumn)) {
      if (board.board[tRow][tColumn] is NoPiece) {
        board.board[tRow][tColumn].showMarker = true;
      } else if (board.board[tRow][tColumn] is! NoPiece &&
          board.board[tRow][tColumn].color != color) {
        board.board[tRow][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
      tRow++;
      tColumn++;
    }

    tRow = row + 1;
    tColumn = column - 1;

    while (withinBounds(tRow, tColumn)) {
      if (board.board[tRow][tColumn] is NoPiece) {
        board.board[tRow][tColumn].showMarker = true;
      } else if (board.board[tRow][tColumn] is! NoPiece &&
          board.board[tRow][tColumn].color != color) {
        board.board[tRow][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
      tRow++;
      tColumn--;
    }

    tRow = row - 1;
    tColumn = column + 1;

    while (withinBounds(tRow, tColumn)) {
      if (board.board[tRow][tColumn] is NoPiece) {
        board.board[tRow][tColumn].showMarker = true;
      } else if (board.board[tRow][tColumn] is! NoPiece &&
          board.board[tRow][tColumn].color != color) {
        board.board[tRow][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
      tRow--;
      tColumn++;
    }

    tRow = row - 1;
    tColumn = column - 1;

    while (withinBounds(tRow, tColumn)) {
      if (board.board[tRow][tColumn] is NoPiece) {
        board.board[tRow][tColumn].showMarker = true;
      } else if (board.board[tRow][tColumn] is! NoPiece &&
          board.board[tRow][tColumn].color != color) {
        board.board[tRow][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
      tRow--;
      tColumn--;
    }
  }

  // @override
  // void destroyPiece(Board board) {}
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
  void showPossibleMoves(Board board) {
    for (int tRow = row + 1; withinBounds(tRow, column); tRow++) {
      if (board.board[tRow][column] is NoPiece) {
        board.board[tRow][column].showMarker = true;
      } else if (board.board[tRow][column] is! NoPiece &&
          board.board[tRow][column].color != color) {
        board.board[tRow][column].showMarker = true;
        break;
      } else {
        break;
      }
    }

    for (int tRow = row - 1; withinBounds(tRow, column); tRow--) {
      if (board.board[tRow][column] is NoPiece) {
        board.board[tRow][column].showMarker = true;
      } else if (board.board[tRow][column] is! NoPiece &&
          board.board[tRow][column].color != color) {
        board.board[tRow][column].showMarker = true;
        break;
      } else {
        break;
      }
    }

    for (int tColumn = column + 1; withinBounds(row, tColumn); tColumn++) {
      if (board.board[row][tColumn] is NoPiece) {
        board.board[row][tColumn].showMarker = true;
      } else if (board.board[row][tColumn] is! NoPiece &&
          board.board[row][tColumn].color != color) {
        board.board[row][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
    }

    for (int tColumn = column - 1; withinBounds(row, tColumn); tColumn--) {
      if (board.board[row][tColumn] is NoPiece) {
        board.board[row][tColumn].showMarker = true;
      } else if (board.board[row][tColumn] is! NoPiece &&
          board.board[row][tColumn].color != color) {
        board.board[row][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
    }
  }

  // @override
  // void destroyPiece(Board board) {}
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
  void showPossibleMoves(Board board) {
    for (int tRow = row + 1; withinBounds(tRow, column); tRow++) {
      if (board.board[tRow][column] is NoPiece) {
        board.board[tRow][column].showMarker = true;
      } else if (board.board[tRow][column] is! NoPiece &&
          board.board[tRow][column].color != color) {
        board.board[tRow][column].showMarker = true;
        break;
      } else {
        break;
      }
    }

    for (int tRow = row - 1; withinBounds(tRow, column); tRow--) {
      if (board.board[tRow][column] is NoPiece) {
        board.board[tRow][column].showMarker = true;
      } else if (board.board[tRow][column] is! NoPiece &&
          board.board[tRow][column].color != color) {
        board.board[tRow][column].showMarker = true;
        break;
      } else {
        break;
      }
    }

    for (int tColumn = column + 1; withinBounds(row, tColumn); tColumn++) {
      if (board.board[row][tColumn] is NoPiece) {
        board.board[row][tColumn].showMarker = true;
      } else if (board.board[row][tColumn] is! NoPiece &&
          board.board[row][tColumn].color != color) {
        board.board[row][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
    }

    for (int tColumn = column - 1; withinBounds(row, tColumn); tColumn--) {
      if (board.board[row][tColumn] is NoPiece) {
        board.board[row][tColumn].showMarker = true;
      } else if (board.board[row][tColumn] is! NoPiece &&
          board.board[row][tColumn].color != color) {
        board.board[row][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
    }

    int tColumn = column + 1;
    int tRow = row + 1;

    while (withinBounds(tRow, tColumn)) {
      if (board.board[tRow][tColumn] is NoPiece) {
        board.board[tRow][tColumn].showMarker = true;
      } else if (board.board[tRow][tColumn] is! NoPiece &&
          board.board[tRow][tColumn].color != color) {
        board.board[tRow][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
      tRow++;
      tColumn++;
    }

    tRow = row + 1;
    tColumn = column - 1;

    while (withinBounds(tRow, tColumn)) {
      if (board.board[tRow][tColumn] is NoPiece) {
        board.board[tRow][tColumn].showMarker = true;
      } else if (board.board[tRow][tColumn] is! NoPiece &&
          board.board[tRow][tColumn].color != color) {
        board.board[tRow][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
      tRow++;
      tColumn--;
    }

    tRow = row - 1;
    tColumn = column + 1;

    while (withinBounds(tRow, tColumn)) {
      if (board.board[tRow][tColumn] is NoPiece) {
        board.board[tRow][tColumn].showMarker = true;
      } else if (board.board[tRow][tColumn] is! NoPiece &&
          board.board[tRow][tColumn].color != color) {
        board.board[tRow][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
      tRow--;
      tColumn++;
    }

    tRow = row - 1;
    tColumn = column - 1;

    while (withinBounds(tRow, tColumn)) {
      if (board.board[tRow][tColumn] is NoPiece) {
        board.board[tRow][tColumn].showMarker = true;
      } else if (board.board[tRow][tColumn] is! NoPiece &&
          board.board[tRow][tColumn].color != color) {
        board.board[tRow][tColumn].showMarker = true;
        break;
      } else {
        break;
      }
      tRow--;
      tColumn--;
    }
  }

  // @override
  // void destroyPiece(Board board) {}
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
  void showPossibleMoves(Board board) {
    if (withinBounds(row + 1, column) &&
        (board.board[row + 1][column] is NoPiece ||
            (board.board[row + 1][column] is! NoPiece &&
                board.board[row + 1][column].color != color))) {
      board.board[row + 1][column].showMarker = true;
    }

    if (withinBounds(row + 1, column + 1) &&
        (board.board[row + 1][column + 1] is NoPiece ||
            (board.board[row + 1][column + 1] is! NoPiece &&
                board.board[row + 1][column + 1].color != color))) {
      board.board[row + 1][column + 1].showMarker = true;
    }

    if (withinBounds(row + 1, column - 1) &&
        (board.board[row + 1][column - 1] is NoPiece ||
            (board.board[row + 1][column - 1] is! NoPiece &&
                board.board[row + 1][column - 1].color != color))) {
      board.board[row + 1][column - 1].showMarker = true;
    }

    if (withinBounds(row, column + 1) &&
        (board.board[row][column + 1] is NoPiece ||
            (board.board[row][column + 1] is! NoPiece &&
                board.board[row][column + 1].color != color))) {
      board.board[row][column + 1].showMarker = true;
    }

    if (withinBounds(row, column - 1) &&
        (board.board[row][column - 1] is NoPiece ||
            (board.board[row][column - 1] is! NoPiece &&
                board.board[row][column - 1].color != color))) {
      board.board[row][column - 1].showMarker = true;
    }

    if (withinBounds(row - 1, column) &&
        (board.board[row - 1][column] is NoPiece ||
            (board.board[row - 1][column] is! NoPiece &&
                board.board[row - 1][column].color != color))) {
      board.board[row - 1][column].showMarker = true;
    }

    if (withinBounds(row - 1, column - 1) &&
        (board.board[row - 1][column - 1] is NoPiece ||
            (board.board[row - 1][column - 1] is! NoPiece &&
                board.board[row - 1][column - 1].color != color))) {
      board.board[row - 1][column - 1].showMarker = true;
    }

    if (withinBounds(row - 1, column + 1) &&
        (board.board[row - 1][column + 1] is NoPiece ||
            (board.board[row - 1][column + 1] is! NoPiece &&
                board.board[row - 1][column + 1].color != color))) {
      board.board[row - 1][column + 1].showMarker = true;
    }
  }

  // @override
  // void updateMe(int destinationRow, int destinationColumn) {
  //   super.updateMe(destinationRow, destinationColumn);
  // }

  // @override
  // void destroyPiece(Board board) {}
}

bool withinBounds(int row, int column) {
  if ((row >= 0 && row <= 7) && (column >= 0 && column <= 7)) {
    return true;
  }
  return false;
}

bool isKing(Piece piece) {
  if (piece is King) {
    return true;
  }
  return false;
}
