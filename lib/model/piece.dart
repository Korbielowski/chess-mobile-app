import 'package:audioplayers/audioplayers.dart';
import 'package:chess/model/board.dart';
import 'package:chess/model/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PieceColor { black, white, noColor }

final AudioPlayer player = AudioPlayer();

abstract class Piece {
  late PieceColor color;
  late int column;
  late int row;
  late Image image;
  bool showMarker = false;

  Piece(this.row, this.column, this.color);
  List<List<int>> getPseudoLegalMoves(List<List<Piece>> board);
  List<List<int>> getLegalMoves(Board board) {
    List<List<int>> legalMoves = [];
    var copiedBoard = board.copy();

    for (var move in getPseudoLegalMoves(copiedBoard)) {
      var tmpPiece = copiedBoard[move[0]][move[1]];
      copiedBoard[move[0]][move[1]] = this;
      copiedBoard[row][column] = NoPiece(row, column, PieceColor.noColor);
      if (!isKingInCheck(color, copiedBoard)) {
        legalMoves.add(move);
      }
      copiedBoard[row][column] = this;
      copiedBoard[move[0]][move[1]] = tmpPiece;
    }

    return legalMoves;
  }

  void showPossibleMoves(Board board) {
    for (var move in getLegalMoves(board)) {
      board.board[move[0]][move[1]].showMarker = true;
    }
  }

  void movePiece(
    Game game,
    Piece piece,
    int destinationRow,
    int destinationColumn,
  ) {
    List<List<Piece>> board = game.board.board;
    board[piece.row][piece.column] = NoPiece(
      piece.row,
      piece.column,
      PieceColor.noColor,
    );
    if (piece is Pawn) {
      if (board[destinationRow - piece.upDown][destinationColumn] is Pawn &&
          board[destinationRow - piece.upDown][destinationColumn].color !=
              piece.color) {
        Pawn attackedPawn =
            board[destinationRow - piece.upDown][destinationColumn] as Pawn;
        if (attackedPawn.isEnPassant) {
          board[destinationRow - piece.upDown][destinationColumn] = NoPiece(
            destinationRow - piece.upDown,
            destinationColumn,
            PieceColor.noColor,
          );
        }
      }
      if (destinationRow == 7 || destinationRow == 0) {
        game.promotionPawn = piece;
      }
    } else if (piece is King &&
        board[destinationRow][destinationColumn] is Rook &&
        board[destinationRow][destinationColumn].color == piece.color) {
      Piece tmpPiece = board[destinationRow][destinationColumn];
      board[piece.row][piece.column] = NoPiece(
        piece.row,
        piece.column,
        PieceColor.noColor,
      );
      if (tmpPiece.column == 0) {
        board[piece.row][piece.column - 2] = piece;
        board[piece.row][piece.column - 1] = tmpPiece;
        tmpPiece.updateMe(piece.row, piece.column - 1);
        piece.updateMe(piece.row, piece.column - 2);
      } else {
        board[piece.row][piece.column + 2] = piece;
        board[piece.row][piece.column + 1] = tmpPiece;
        tmpPiece.updateMe(piece.row, piece.column + 1);
        piece.updateMe(piece.row, piece.column + 2);
      }
      board[destinationRow][destinationColumn] = NoPiece(
        destinationRow,
        destinationColumn,
        PieceColor.noColor,
      );
      playSound("sounds/castling_sound.wav");
      return;
    }
    if (board[destinationRow][destinationColumn] is! NoPiece) {
      board[destinationRow][destinationColumn] = NoPiece(
        destinationRow,
        destinationColumn,
        PieceColor.noColor,
      );
      playSound("sounds/capture_sound.wav");
    } else {
      playSound("sounds/move_sound.wav");
    }
    piece.updateMe(destinationRow, destinationColumn);
    board[destinationRow][destinationColumn] = piece;
    // print(
    //   "I am: $piece, my pos: ${piece.row}, ${piece.column}, my color: ${piece.color}",
    // );
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

  @override
  List<List<int>> getPseudoLegalMoves(List<List<Piece>> board) {
    return [];
  }

  // @override
  // void destroyPiece(Board board) {}
}

class Pawn extends Piece {
  bool isFirstMove = true;
  bool isEnPassant = false;
  late int upDown;

  Pawn(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/normal_pieces/white_pawn.png");
    } else {
      image = Image.asset("assets/pieces/normal_pieces/black_pawn.png");
    }
    upDown = (color == PieceColor.white) ? -1 : 1;
  }

  @override
  List<List<int>> getPseudoLegalMoves(List<List<Piece>> board) {
    List<List<int>> moves = [];
    // Determine whether to move up or down, determined by color of a piece

    // First move, able to move by two rows
    if (isFirstMove &&
        board[row + upDown][column] is NoPiece &&
        board[row + 2 * upDown][column] is NoPiece) {
      moves.add([row + 2 * upDown, column]);
    }

    // Normal move by one row
    if (withinBounds(row + upDown, column) &&
        board[row + upDown][column] is NoPiece) {
      moves.add([row + upDown, column]);
    }

    // Attack right
    if (withinBounds(row + upDown, column + 1) &&
        board[row + upDown][column + 1] is! NoPiece &&
        // !isKing(board[row + upDown][column + 1]) &&
        board[row + upDown][column + 1].color != color) {
      moves.add([row + upDown, column + 1]);
    }

    // Attack left
    if (withinBounds(row + upDown, column - 1) &&
        board[row + upDown][column - 1] is! NoPiece &&
        // !isKing(board[row + upDown][column - 1]) &&
        board[row + upDown][column - 1].color != color) {
      moves.add([row + upDown, column - 1]);
    }

    // En Passant right
    if (withinBounds(row, column - 1) && board[row][column - 1] is Pawn) {
      Pawn tmpPawn = board[row][column - 1] as Pawn;
      if (tmpPawn.isEnPassant && tmpPawn.color != color) {
        moves.add([row, column - 1]);
      }
    }

    // En Passant left
    if (withinBounds(row, column + 1) && board[row][column + 1] is Pawn) {
      Pawn tmpPawn = board[row][column + 1] as Pawn;
      if (tmpPawn.isEnPassant && tmpPawn.color != color) {
        moves.add([row, column + 1]);
      }
    }

    return moves;
  }

  @override
  updateMe(destinationRow, destinationColumn) {
    if (isFirstMove == true) {
      isFirstMove = false;
      if ((destinationRow - row).abs() == 2) {
        isEnPassant = true;
      }
    } else {
      isEnPassant = false;
    }
    super.updateMe(destinationRow, destinationColumn);
  }

  promoteMe(List<List<Piece>> board, int toWhat) {
    if (toWhat == 1) {
      board[row][column] = Queen(row, column, color);
    } else if (toWhat == 2) {
      board[row][column] = Rook(row, column, color);
    } else if (toWhat == 3) {
      board[row][column] = Bishop(row, column, color);
    } else if (toWhat == 4) {
      board[row][column] = Knight(row, column, color);
    }
  }

  // @override
  // void destroyPiece(Board board) {}
}

class Knight extends Piece {
  Knight(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/normal_pieces/white_knight.png");
    } else {
      image = Image.asset("assets/pieces/normal_pieces/black_knight.png");
    }
  }

  @override
  List<List<int>> getPseudoLegalMoves(List<List<Piece>> board) {
    List<List<int>> moves = [];

    if (withinBounds(row + 2, column + 1) &&
        (board[row + 2][column + 1] is NoPiece ||
            (board[row + 2][column + 1] is! NoPiece &&
                // !isKing(board[row + 2][column + 1]) &&
                board[row + 2][column + 1].color != color))) {
      moves.add([row + 2, column + 1]);
    }

    if (withinBounds(row + 2, column - 1) &&
        (board[row + 2][column - 1] is NoPiece ||
            (board[row + 2][column - 1] is! NoPiece &&
                // !isKing(board[row + 2][column - 1]) &&
                board[row + 2][column - 1].color != color))) {
      moves.add([row + 2, column - 1]);
    }

    if (withinBounds(row + 1, column + 2) &&
        (board[row + 1][column + 2] is NoPiece ||
            (board[row + 1][column + 2] is! NoPiece &&
                // !isKing(board[row + 1][column + 2]) &&
                board[row + 1][column + 2].color != color))) {
      moves.add([row + 1, column + 2]);
    }

    if (withinBounds(row - 1, column + 2) &&
        (board[row - 1][column + 2] is NoPiece ||
            (board[row - 1][column + 2] is! NoPiece &&
                // !isKing(board[row - 1][column + 2]) &&
                board[row - 1][column + 2].color != color))) {
      moves.add([row - 1, column + 2]);
    }

    if (withinBounds(row - 2, column + 1) &&
        (board[row - 2][column + 1] is NoPiece ||
            (board[row - 2][column + 1] is! NoPiece &&
                // !isKing(board[row - 2][column + 1]) &&
                board[row - 2][column + 1].color != color))) {
      moves.add([row - 2, column + 1]);
    }

    if (withinBounds(row - 2, column - 1) &&
        (board[row - 2][column - 1] is NoPiece ||
            (board[row - 2][column - 1] is! NoPiece &&
                // !isKing(board[row - 2][column - 1]) &&
                board[row - 2][column - 1].color != color))) {
      moves.add([row - 2, column - 1]);
    }

    if (withinBounds(row - 1, column - 2) &&
        (board[row - 1][column - 2] is NoPiece ||
            (board[row - 1][column - 2] is! NoPiece &&
                // !isKing(board[row - 1][column - 2]) &&
                board[row - 1][column - 2].color != color))) {
      moves.add([row - 1, column - 2]);
    }

    if (withinBounds(row + 1, column - 2) &&
        (board[row + 1][column - 2] is NoPiece ||
            (board[row + 1][column - 2] is! NoPiece &&
                // !isKing(board[row + 1][column - 2]) &&
                board[row + 1][column - 2].color != color))) {
      moves.add([row + 1, column - 2]);
    }

    return moves;
  }

  // @override
  // void destroyPiece(Board board) {}
}

class Bishop extends Piece {
  Bishop(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/normal_pieces/white_bishop.png");
    } else {
      image = Image.asset("assets/pieces/normal_pieces/black_bishop.png");
    }
  }

  @override
  List<List<int>> getPseudoLegalMoves(List<List<Piece>> board) {
    List<List<int>> moves = [];
    int tColumn = column + 1;
    int tRow = row + 1;

    while (withinBounds(tRow, tColumn)) {
      if (board[tRow][tColumn] is NoPiece) {
        moves.add([tRow, tColumn]);
      } else if (board[tRow][tColumn] is! NoPiece &&
          // !isKing(board[tRow][tColumn]) &&
          board[tRow][tColumn].color != color) {
        moves.add([tRow, tColumn]);
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
      if (board[tRow][tColumn] is NoPiece) {
        moves.add([tRow, tColumn]);
      } else if (board[tRow][tColumn] is! NoPiece &&
          // !isKing(board[tRow][tColumn]) &&
          board[tRow][tColumn].color != color) {
        moves.add([tRow, tColumn]);
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
      if (board[tRow][tColumn] is NoPiece) {
        moves.add([tRow, tColumn]);
      } else if (board[tRow][tColumn] is! NoPiece &&
          // !isKing(board[tRow][tColumn]) &&
          board[tRow][tColumn].color != color) {
        moves.add([tRow, tColumn]);
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
      if (board[tRow][tColumn] is NoPiece) {
        moves.add([tRow, tColumn]);
      } else if (board[tRow][tColumn] is! NoPiece &&
          // !isKing(board[tRow][tColumn]) &&
          board[tRow][tColumn].color != color) {
        moves.add([tRow, tColumn]);
        break;
      } else {
        break;
      }
      tRow--;
      tColumn--;
    }
    return moves;
  }

  // @override
  // void destroyPiece(Board board) {}
}

class Rook extends Piece {
  Rook(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/normal_pieces/white_rook.png");
    } else {
      image = Image.asset("assets/pieces/normal_pieces/black_rook.png");
    }
  }

  @override
  List<List<int>> getPseudoLegalMoves(List<List<Piece>> board) {
    List<List<int>> moves = [];

    for (int tRow = row + 1; withinBounds(tRow, column); tRow++) {
      if (board[tRow][column] is NoPiece) {
        moves.add([tRow, column]);
      } else if (board[tRow][column] is! NoPiece &&
          // !isKing(board[tRow][column]) &&
          board[tRow][column].color != color) {
        moves.add([tRow, column]);
        break;
      } else {
        break;
      }
    }

    for (int tRow = row - 1; withinBounds(tRow, column); tRow--) {
      if (board[tRow][column] is NoPiece) {
        moves.add([tRow, column]);
      } else if (board[tRow][column] is! NoPiece &&
          // !isKing(board[tRow][column]) &&
          board[tRow][column].color != color) {
        moves.add([tRow, column]);
        break;
      } else {
        break;
      }
    }

    for (int tColumn = column + 1; withinBounds(row, tColumn); tColumn++) {
      if (board[row][tColumn] is NoPiece) {
        moves.add([row, tColumn]);
      } else if (board[row][tColumn] is! NoPiece &&
          // !isKing(board[row][tColumn]) &&
          board[row][tColumn].color != color) {
        moves.add([row, tColumn]);
        break;
      } else {
        break;
      }
    }

    for (int tColumn = column - 1; withinBounds(row, tColumn); tColumn--) {
      if (board[row][tColumn] is NoPiece) {
        moves.add([row, tColumn]);
      } else if (board[row][tColumn] is! NoPiece &&
          // !isKing(board[row][tColumn]) &&
          board[row][tColumn].color != color) {
        moves.add([row, tColumn]);
        break;
      } else {
        break;
      }
    }

    return moves;
  }

  // @override
  // void destroyPiece(Board board) {}
}

class Queen extends Piece {
  Queen(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/normal_pieces/white_queen.png");
    } else {
      image = Image.asset("assets/pieces/normal_pieces/black_queen.png");
    }
  }

  @override
  List<List<int>> getPseudoLegalMoves(List<List<Piece>> board) {
    List<List<int>> moves = [];

    for (int tRow = row + 1; withinBounds(tRow, column); tRow++) {
      if (board[tRow][column] is NoPiece) {
        moves.add([tRow, column]);
      } else if (board[tRow][column] is! NoPiece &&
          // !isKing(board[tRow][column]) &&
          board[tRow][column].color != color) {
        moves.add([tRow, column]);
        break;
      } else {
        break;
      }
    }

    for (int tRow = row - 1; withinBounds(tRow, column); tRow--) {
      if (board[tRow][column] is NoPiece) {
        moves.add([tRow, column]);
      } else if (board[tRow][column] is! NoPiece &&
          // !isKing(board[tRow][column]) &&
          board[tRow][column].color != color) {
        moves.add([tRow, column]);
        break;
      } else {
        break;
      }
    }

    for (int tColumn = column + 1; withinBounds(row, tColumn); tColumn++) {
      if (board[row][tColumn] is NoPiece) {
        moves.add([row, tColumn]);
      } else if (board[row][tColumn] is! NoPiece &&
          // !isKing(board[row][tColumn]) &&
          board[row][tColumn].color != color) {
        moves.add([row, tColumn]);
        break;
      } else {
        break;
      }
    }

    for (int tColumn = column - 1; withinBounds(row, tColumn); tColumn--) {
      if (board[row][tColumn] is NoPiece) {
        moves.add([row, tColumn]);
      } else if (board[row][tColumn] is! NoPiece &&
          // !isKing(board[row][tColumn]) &&
          board[row][tColumn].color != color) {
        moves.add([row, tColumn]);
        break;
      } else {
        break;
      }
    }

    int tColumn = column + 1;
    int tRow = row + 1;

    while (withinBounds(tRow, tColumn)) {
      if (board[tRow][tColumn] is NoPiece) {
        moves.add([tRow, tColumn]);
      } else if (board[tRow][tColumn] is! NoPiece &&
          // !isKing(board[tRow][tColumn]) &&
          board[tRow][tColumn].color != color) {
        moves.add([tRow, tColumn]);
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
      if (board[tRow][tColumn] is NoPiece) {
        moves.add([tRow, tColumn]);
      } else if (board[tRow][tColumn] is! NoPiece &&
          // !isKing(board[tRow][tColumn]) &&
          board[tRow][tColumn].color != color) {
        moves.add([tRow, tColumn]);
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
      if (board[tRow][tColumn] is NoPiece) {
        moves.add([tRow, tColumn]);
      } else if (board[tRow][tColumn] is! NoPiece &&
          // !isKing(board[tRow][tColumn]) &&
          board[tRow][tColumn].color != color) {
        moves.add([tRow, tColumn]);
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
      if (board[tRow][tColumn] is NoPiece) {
        moves.add([tRow, tColumn]);
      } else if (board[tRow][tColumn] is! NoPiece &&
          // !isKing(board[tRow][tColumn]) &&
          board[tRow][tColumn].color != color) {
        moves.add([tRow, tColumn]);
        break;
      } else {
        break;
      }
      tRow--;
      tColumn--;
    }

    return moves;
  }

  // @override
  // void destroyPiece(Board board) {}
}

class King extends Piece {
  bool isCastling = true;
  King(super.row, super.column, super.color) {
    if (color == PieceColor.white) {
      image = Image.asset("assets/pieces/normal_pieces/white_king.png");
    } else {
      image = Image.asset("assets/pieces/normal_pieces/black_king.png");
    }
  }

  @override
  List<List<int>> getLegalMoves(Board board) {
    var pseudoMoves = getPseudoLegalMoves(board.board);
    List<List<int>> legalMoves = [];

    for (var move in pseudoMoves) {
      var copiedBoard = board.copy();
      copiedBoard[move[0]][move[1]] = this;
      copiedBoard[row][column] = NoPiece(row, column, PieceColor.noColor);

      if (!isSquareAttacked(move[0], move[1], color, copiedBoard)) {
        legalMoves.add(move);
      }
    }

    return legalMoves;
  }

  @override
  List<List<int>> getPseudoLegalMoves(List<List<Piece>> board) {
    List<List<int>> moves = [];

    for (int tRow = -1; tRow <= 1; tRow++) {
      for (int tColumn = -1; tColumn <= 1; tColumn++) {
        if (withinBounds(row + tRow, column + tColumn) &&
            (board[row + tRow][column + tColumn] is NoPiece ||
                (board[row + tRow][column + tColumn] is! NoPiece &&
                    board[row + tRow][column + tColumn].color != color)) &&
            !isKingAround(row + tRow, column + tColumn, board)) {
          moves.add([row + tRow, column + tColumn]);
        }
      }
    }

    if (isCastling == true) {
      for (int tColumn = column + 1; tColumn <= 7; tColumn++) {
        if (board[row][tColumn] is! NoPiece && tColumn < 7) {
          break;
        }
        if (board[row][tColumn] is Rook && board[row][tColumn].color == color) {
          moves.add([row, tColumn]);
        }
      }
      for (int tColumn = column - 1; tColumn >= 0; tColumn--) {
        if (board[row][tColumn] is! NoPiece && tColumn > 0) {
          break;
        }
        if (board[row][tColumn] is Rook && board[row][tColumn].color == color) {
          moves.add([row, tColumn]);
        }
      }
    }

    return moves;
  }

  // Naive approach, probably there is a better way to do this
  bool isKingAround(
    int rowToCheck,
    int columnToCheck,
    List<List<Piece>> board,
  ) {
    for (int tRow = -1; tRow <= 1; tRow++) {
      for (int tColumn = -1; tColumn <= 1; tColumn++) {
        if (withinBounds(rowToCheck + tRow, columnToCheck + tColumn) &&
            board[rowToCheck + tRow][columnToCheck + tColumn] is King &&
            board[rowToCheck + tRow][columnToCheck + tColumn].color != color) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  void updateMe(int destinationRow, int destinationColumn) {
    super.updateMe(destinationRow, destinationColumn);
    isCastling = false;
  }

  // @override
  // void destroyPiece(Board board) {}
}

bool withinBounds(int row, int column) {
  if ((row >= 0 && row <= 7) && (column >= 0 && column <= 7)) {
    return true;
  }
  return false;
}

// bool isKing(Piece piece) {
//   if (piece is King) {
//     return true;
//   }
//   return false;
// }

Future<void> playSound(String path) async {
  await player.play(AssetSource(path));
}

bool isKingInCheck(PieceColor color, List<List<Piece>> board) {
  King? king;

  for (var row in board) {
    for (var piece in row) {
      if (piece is King && piece.color == color) {
        king = piece;
        break;
      }
    }
  }

  if (king == null) {
    // print("King NOT in check 1");
    return false;
  }

  for (var row in board) {
    for (var piece in row) {
      // print("from $piece and color: ${piece.color}");
      if (piece.color != color && piece.color != PieceColor.noColor) {
        var pseudoMoves = piece.getPseudoLegalMoves(board);
        // print("Pseudo moves: $piece ${piece.color} $pseudoMoves");
        // print("King: ${king.row}, ${king.column}, ${king.color}");
        for (var move in pseudoMoves) {
          if (move.isNotEmpty &&
              move[0] == king.row &&
              move[1] == king.column) {
            // print("King in check");
            return true;
          }
        }
      }
    }
  }
  // print("King NOT in check 2");
  return false;
}

bool isSquareAttacked(
  int targetRow,
  int targetCol,
  PieceColor kingColor,
  List<List<Piece>> board,
) {
  for (var row in board) {
    for (var piece in row) {
      if (piece.color != kingColor && piece.color != PieceColor.noColor) {
        var enemyMoves = piece.getPseudoLegalMoves(board);
        for (var move in enemyMoves) {
          if (move[0] == targetRow && move[1] == targetCol) {
            return true;
          }
        }
      }
    }
  }
  return false;
}
