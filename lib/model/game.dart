import 'dart:io';

import 'package:chess/model/board.dart';
import 'package:chess/model/piece.dart';
import 'package:chess/model/player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> loadBoard() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/pieces.txt');

    if (await file.exists()) {
      final content = await file.readAsString();
      print(content);
      List<String> lines = content.split("\n");
      for (int row = 0; row < 8; row++) {
        List<String> pieces = lines[row].split(",");
        for (int column = 0; column < 8; column++) {
          String piece = pieces[column];
          PieceColor color = PieceColor.noColor;
          if (piece[1] == 'w') {
            color = PieceColor.white;
          } else if (piece[1] == 'b') {
            color = PieceColor.black;
          }
          if (piece[0] == '0') {
            board.board[row][column] = NoPiece(row, column, color);
          } else if (piece[0] == '1') {
            board.board[row][column] = Pawn(row, column, color);
          } else if (piece[0] == '2') {
            board.board[row][column] = Bishop(row, column, color);
          } else if (piece[0] == '3') {
            board.board[row][column] = Knight(row, column, color);
          } else if (piece[0] == '5') {
            board.board[row][column] = Rook(row, column, color);
          } else if (piece[0] == '9') {
            board.board[row][column] = Queen(row, column, color);
          } else if (piece[0] == '7') {
            board.board[row][column] = King(row, column, color);
          }
        }
      }
    }

    final pFile = File('${dir.path}/which_player.txt');
    if (await pFile.exists()) {
      final pContent = await pFile.readAsString();
      if (pContent[0] == '1') {
        currentPlayer = players[0];
      } else {
        currentPlayer = players[1];
      }
    }
    notifyListeners();
  }
}
