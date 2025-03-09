import 'package:chess/model/board.dart';

enum PieceColor { black, white, noColor }

abstract class Piece {
  late PieceColor color;
  late int column;
  late int row;
  // bool showMarker = false;

  Piece(this.row, this.column, this.color);
  void showPossibleMoves(Board board);
  void movePiece(Board board, int markerRow, int markerColumn);
  void destroyPiece(Board board);
}

class NoPiece extends Piece {
  NoPiece(super.row, super.column, super.color);

  @override
  void showPossibleMoves(Board board) {}
  @override
  void movePiece(Board board, int markerRow, int markerColumn) {}
  @override
  void destroyPiece(Board board) {}
}

class Pawn extends Piece {
  bool isFirstMove = true;
  bool isEnPassant = false;

  Pawn(super.row, super.column, super.color);

  @override
  void showPossibleMoves(Board board) {}

  @override
  void movePiece(Board board, int markerRow, int markerColumn) {}

  @override
  void destroyPiece(Board board) {}
}

class Knight extends Piece {
  Knight(super.row, super.column, super.color);
}

class Bishop extends Piece {
  Bishop(super.row, super.column, super.color);
}

class Rook extends Piece {
  Rook(super.row, super.column, super.color);
}

class Queen extends Piece {
  Queen(super.row, super.column, super.color);
}

class King extends Piece {
  King(super.row, super.column, super.color);
}
