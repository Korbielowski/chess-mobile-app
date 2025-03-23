// // import 'dart:ui';

// import 'package:flutter/cupertino.dart';

// enum Color { white, black }

// class Piece {
//   late int value;
//   late Color color;
//   late int row;
//   late int column;
//   late Image image;

//   Piece(this.row, this.column, this.color);
//   void movePiece(List<List<Piece?>> board) {}
//   void destroyPiece() {}
//   void drawPossibleMoves() {}
//   Image getPieceImage() {
//     return image;
//   }

//   showMoves(List<List<Piece?>> board) {}
// }

// class Pawn extends Piece {
//   bool isFirstMove = true;
//   bool isEnPassant = false;

//   Pawn(super.row, super.column, super.color) {
//     if (color == Color.white) {
//       image = Image.asset("assets/pieces/white_pawn.png");
//     } else {
//       image = Image.asset("assets/pieces/black_pawn.png");
//     }
//   }

//   @override
//   showMoves(List<List<Piece?>> board) {
//     if (row + 1 > 7) {
//       return;
//     }
//     board[row - 1][column] = Marker(row - 1, column, color, row, column);
//     board[row - 2][column] = Marker(row - 2, column, color, row, column);
//     // if (board[row + 1][column]) {}
//   }
// }

// class Bishop extends Piece {
//   Bishop(super.row, super.column, super.color) {
//     if (color == Color.white) {
//       image = Image.asset("assets/pieces/white_bishop.png");
//     } else {
//       image = Image.asset("assets/pieces/black_bishop.png");
//     }
//   }
// }

// class Knight extends Piece {
//   Knight(super.row, super.column, super.color) {
//     if (color == Color.white) {
//       image = Image.asset("assets/pieces/white_knight.png");
//     } else {
//       image = Image.asset("assets/pieces/black_knight.png");
//     }
//   }
// }

// class Rook extends Piece {
//   Rook(super.row, super.column, super.color) {
//     if (color == Color.white) {
//       image = Image.asset("assets/pieces/white_rook.png");
//     } else {
//       image = Image.asset("assets/pieces/black_rook.png");
//     }
//   }
// }

// class Queen extends Piece {
//   Queen(super.row, super.column, super.color) {
//     if (color == Color.white) {
//       image = Image.asset("assets/pieces/white_queen.png");
//     } else {
//       image = Image.asset("assets/pieces/black_queen.png");
//     }
//   }
// }

// class King extends Piece {
//   bool isCastlingPossible = true;
//   bool isChecked = false;
//   bool isCheckMated = false;

//   King(super.row, super.column, super.color) {
//     if (color == Color.white) {
//       image = Image.asset("assets/pieces/white_king.png");
//     } else {
//       image = Image.asset("assets/pieces/black_king.png");
//     }
//   }
// }

// class Marker extends Piece {
//   late int pieceRow;
//   late int pieceColumn;

//   Marker(
//     super.row,
//     super.column,
//     super.color,
//     this.pieceRow,
//     this.pieceColumn,
//   ) {
//     image = Image.asset("assets/pieces/dot.png");
//   }

//   @override
//   void movePiece(List<List<Piece?>> board) {
//     Piece? piece = board[pieceRow][pieceColumn];
//     board[pieceRow][pieceColumn] = null;
//     board[row][column] = piece;
//   }
// }
