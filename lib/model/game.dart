import 'package:chess/model/board.dart';
import 'package:chess/model/piece.dart';
import 'package:chess/model/player.dart';
import 'package:flutter/material.dart';

class Game extends ChangeNotifier {
  Board board = Board();
  List<Player> players = [
    Player(10, PieceColor.white),
    Player(10, PieceColor.black),
  ];
  late Player currentPlayer;
  Pawn? promotionPawn;
  Game() {
    currentPlayer = players[0];
    // TODO: Work on time feature in third mile stone, when other things are done
    // currentPlayer.timer.start();
  }

  void tileClicked(BuildContext context, int row, int column) {
    board.tileClicked(this, row, column);
    notifyListeners();
  }

  void promotePawn(int toWhat) {
    promotionPawn?.promoteMe(board.board, toWhat);
    promotionPawn = null;
    switchPlayer();
    notifyListeners();
  }

  void switchPlayer() {
    if (promotionPawn != null) {
      return;
    }
    // currentPlayer.timer.stop();
    if (currentPlayer.color == PieceColor.white) {
      currentPlayer = players[1];
    } else {
      currentPlayer = players[0];
    }
    // currentPlayer.timer.start();
  }

  void endGame() {
    // players[0].timer.stop();
    // players[1].timer.stop();
  }

  void updatePieceAssets(String directory) {
    for (int row = 0; row < 8; row++) {
      for (int column = 0; column < 8; column++) {
        if (board.board[row][column].color == PieceColor.white) {
          if (board.board[row][column] is Pawn) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/white_pawn.png",
            );
          } else if (board.board[row][column] is Bishop) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/white_bishop.png",
            );
          } else if (board.board[row][column] is Knight) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/white_knight.png",
            );
          } else if (board.board[row][column] is Rook) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/white_rook.png",
            );
          } else if (board.board[row][column] is Queen) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/white_queen.png",
            );
          } else if (board.board[row][column] is King) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/white_king.png",
            );
          }
        } else {
          if (board.board[row][column] is Pawn) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/black_pawn.png",
            );
          } else if (board.board[row][column] is Bishop) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/black_bishop.png",
            );
          } else if (board.board[row][column] is Knight) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/black_knight.png",
            );
          } else if (board.board[row][column] is Rook) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/black_rook.png",
            );
          } else if (board.board[row][column] is Queen) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/black_queen.png",
            );
          } else if (board.board[row][column] is King) {
            board.board[row][column].image = Image.asset(
              "assets/pieces/$directory/black_king.png",
            );
          }
        }
      }
    }
  }
}
