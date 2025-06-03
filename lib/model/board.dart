import 'package:chess/model/game.dart';
import 'package:chess/model/piece.dart';
import 'package:flutter/material.dart';

class Board {
  late List<List<Piece>> board;
  late Piece selectedPiece;

  Board() {
    board = List.generate(
      8,
      (i) => List.filled(8, NoPiece(-1, -1, PieceColor.noColor)),
    );

    List<List<int>> tmpBoard = [
      [5, 3, 2, 9, 7, 2, 3, 5],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [5, 3, 2, 9, 7, 2, 3, 5],
    ];

    // List<List<int>> tmpBoard = [
    //   [7, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 7, 0, 0, 0, 9],
    //   [0, 0, 0, 0, 0, 0, 0, 0],
    // ];

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
        } else if (pieceValue == 7) {
          board[row][column] = King(row, column, color);
        }
      }
    }
  }

  void zeroPossibleMoves() {
    for (int row = 0; row < 8; row++) {
      for (int column = 0; column < 8; column++) {
        if (board[row][column].showMarker == true) {
          board[row][column].showMarker = false;
        }
      }
    }
  }

  void tileClicked(Game game, BuildContext context, int row, int column) {
    Piece piece = board[row][column];

    if (game.promotionPawn != null &&
        (piece.row != game.promotionPawn?.row ||
            piece.column != game.promotionPawn?.column)) {
      return;
    }

    if (piece.showMarker == false && game.currentPlayer.color != piece.color) {
      zeroPossibleMoves();
      return;
    }

    if (piece is! NoPiece && piece.showMarker == false) {
      zeroPossibleMoves();
      piece.showPossibleMoves(this);
      selectedPiece = piece;
    } else if (piece is! NoPiece && piece.showMarker == true) {
      piece.movePiece(game, selectedPiece, row, column);
      zeroPossibleMoves();
      clearEnPassant(game);
      game.switchPlayer();
    } else if (piece is NoPiece && piece.showMarker == false) {
      zeroPossibleMoves();
    } else if (piece is NoPiece && piece.showMarker == true) {
      piece.movePiece(game, selectedPiece, row, column);
      zeroPossibleMoves();
      clearEnPassant(game);
      game.switchPlayer();
    }

    handleCheckmateOrStalemate(game, context);
  }

  List<List<Piece>> copy() {
    List<List<Piece>> copiedBoard = List.generate(
      8,
      (_) => List<Piece>.filled(8, NoPiece(0, 0, PieceColor.noColor)),
    );

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        copiedBoard[row][col] = board[row][col];
      }
    }

    return copiedBoard;
  }

  void handleCheckmateOrStalemate(Game game, BuildContext context) {
    PieceColor currentColor = game.currentPlayer.color;

    bool isInCheck = isKingInCheck(currentColor, board);
    bool hasLegalMove = false;

    for (var row in board) {
      for (var piece in row) {
        if (piece.color == currentColor) {
          var legalMoves = piece.getLegalMoves(this);
          if (legalMoves.isNotEmpty) {
            hasLegalMove = true;
            break;
          }
        }
      }
      if (hasLegalMove) break;
    }

    if (isInCheck && !hasLegalMove) {
      if (game.currentPlayer.color == PieceColor.black) {
        game.endGame("Checkmate! White wins", context);
      } else {
        game.endGame("Checkmate! Black wins", context);
      }
    } else if (!isInCheck && !hasLegalMove) {
      game.endGame("Stalemate! It's a draw.", context);
    } else if (isInCheck && hasLegalMove) {
      print("Check!");
    }
  }

  void clearEnPassant(Game game) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (board[row][col] is Pawn &&
            board[row][col].color != game.currentPlayer.color) {
          Pawn pawn = board[row][col] as Pawn;
          pawn.isEnPassant = false;
        }
      }
    }
  }
}
