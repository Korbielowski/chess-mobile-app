import 'dart:io';

import 'package:chess/model/game.dart';
import 'package:chess/model/piece.dart';
import 'package:chess/riverpod.dart';
import 'package:chess/settings_screen.dart';
import 'package:chess/widgets/circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class GameScreen extends ConsumerWidget {
  final Color lightPiecesColor;
  final Color darkPiecesColor;
  final Color lightSquaresColor;
  final Color darkSquaresColor;

  const GameScreen({
    super.key,
    this.lightPiecesColor = Colors.white,
    this.darkPiecesColor = Colors.black,
    this.lightSquaresColor = Colors.white,
    this.darkSquaresColor = Colors.brown,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileSize = MediaQuery.of(context).size.width / 8;
    final game = ref.watch(gameProvider);
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: Icon(Icons.settings, color: Colors.white, size: 30.0),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SettingsScreen(
                          lightPiecesColor: lightPiecesColor,
                          darkPiecesColor: darkPiecesColor,
                          lightSquaresColor: lightSquaresColor,
                          darkSquaresColor: darkSquaresColor,
                          game: game,
                        ),
                  ),
                );
              },
            ),
            SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: () => {_saveGameToFile(game)},
              child: Text(style: TextStyle(color: Colors.black), "Save game"),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (game.promotionPawn != null &&
              game.promotionPawn?.color == PieceColor.black)
            Row(
              children: [
                Container(
                  color: Colors.grey,
                  child: IconButton(
                    icon:
                        (game.promotionPawn?.color == PieceColor.black)
                            ? Image.asset(
                              "assets/pieces/normal_pieces/black_queen.png",
                            )
                            : Image.asset(
                              "assets/pieces/normal_pieces/white_queen.png",
                            ),
                    onPressed: () => {game.promotePawn(1)},
                  ),
                ),
                Container(
                  color: Colors.grey,
                  child: IconButton(
                    icon:
                        (game.promotionPawn?.color == PieceColor.black)
                            ? Image.asset(
                              "assets/pieces/normal_pieces/black_rook.png",
                            )
                            : Image.asset(
                              "assets/pieces/normal_pieces/white_rook.png",
                            ),
                    onPressed: () => {game.promotePawn(2)},
                  ),
                ),
                Container(
                  color: Colors.grey,
                  child: IconButton(
                    icon:
                        (game.promotionPawn?.color == PieceColor.black)
                            ? Image.asset(
                              "assets/pieces/normal_pieces/black_bishop.png",
                            )
                            : Image.asset(
                              "assets/pieces/normal_pieces/white_bishop.png",
                            ),
                    onPressed: () => {game.promotePawn(3)},
                  ),
                ),
                Container(
                  color: Colors.grey,
                  child: IconButton(
                    icon:
                        (game.promotionPawn?.color == PieceColor.black)
                            ? Image.asset(
                              "assets/pieces/normal_pieces/black_knight.png",
                            )
                            : Image.asset(
                              "assets/pieces/normal_pieces/white_knight.png",
                            ),
                    onPressed: () => {game.promotePawn(4)},
                  ),
                ),
              ],
            ),
          Center(
            child: SizedBox(
              height: tileSize * 9,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) {
                  return _getBoard(
                    context,
                    index,
                    tileSize,
                    game,
                    lightPiecesColor,
                    darkPiecesColor,
                    lightSquaresColor,
                    darkSquaresColor,
                  );
                },
                itemCount: 8 * 8,
              ),
            ),
          ),
          if (game.promotionPawn != null &&
              game.promotionPawn?.color == PieceColor.white)
            Row(
              children: [
                Container(
                  color: Colors.grey,
                  child: IconButton(
                    icon:
                        (game.promotionPawn?.color == PieceColor.black)
                            ? Image.asset(
                              "assets/pieces/normal_pieces/black_queen.png",
                            )
                            : Image.asset(
                              "assets/pieces/normal_pieces/white_queen.png",
                            ),
                    onPressed: () => {game.promotePawn(1)},
                  ),
                ),
                Container(
                  color: Colors.grey,
                  child: IconButton(
                    icon:
                        (game.promotionPawn?.color == PieceColor.black)
                            ? Image.asset(
                              "assets/pieces/normal_pieces/black_rook.png",
                            )
                            : Image.asset(
                              "assets/pieces/normal_pieces/white_rook.png",
                            ),
                    onPressed: () => {game.promotePawn(2)},
                  ),
                ),
                Container(
                  color: Colors.grey,
                  child: IconButton(
                    icon:
                        (game.promotionPawn?.color == PieceColor.black)
                            ? Image.asset(
                              "assets/pieces/normal_pieces/black_bishop.png",
                            )
                            : Image.asset(
                              "assets/pieces/normal_pieces/white_bishop.png",
                            ),
                    onPressed: () => {game.promotePawn(3)},
                  ),
                ),
                Container(
                  color: Colors.grey,
                  child: IconButton(
                    icon:
                        (game.promotionPawn?.color == PieceColor.black)
                            ? Image.asset(
                              "assets/pieces/normal_pieces/black_knight.png",
                            )
                            : Image.asset(
                              "assets/pieces/normal_pieces/white_knight.png",
                            ),
                    onPressed: () => {game.promotePawn(4)},
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

Widget _getBoard(
  BuildContext context,
  int index,
  double tileSize,
  Game game,
  Color lightPiecesColor,
  Color darkPiecesColor,
  Color lightSquaresColor,
  Color darkSquaresColor,
) {
  int row, column = 0;
  row = (index / 8).floor();
  column = (index % 8);
  return GestureDetector(
    onTap: () => game.tileClicked(context, row, column),
    child: GridTile(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: tileSize,
            height: tileSize,
            decoration: BoxDecoration(
              color:
                  ((row + column) % 2 != 0)
                      ? darkSquaresColor
                      : lightSquaresColor,
              // border: Border.all(color: Colors.black, width: 0.5),
            ),
            child:
                (game.board.board[row][column] is! NoPiece)
                    ? Center(
                      child:
                          (lightPiecesColor != Colors.white ||
                                  darkPiecesColor != Colors.black)
                              ? ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  darkPiecesColor,
                                  BlendMode.color,
                                ),
                                child: game.board.board[row][column].image,
                              )
                              : game.board.board[row][column].image,
                    )
                    : null,
          ),
          CircleWidget(row, column),
        ],
      ),
    ),
  );
}

Future<void> _saveGameToFile(Game game) async {
  List<List<Piece>> board = game.board.board;
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/pieces.txt');
  file.writeAsStringSync('');
  for (int row = 0; row < 8; row++) {
    for (int column = 0; column < 8; column++) {
      String c = "n";
      if (board[row][column].color == PieceColor.white) {
        c = "w";
      } else if (board[row][column].color == PieceColor.black) {
        c = "b";
      }
      if (board[row][column] is Pawn) {
        file.writeAsStringSync("1$c,", mode: FileMode.append);
      } else if (board[row][column] is Bishop) {
        file.writeAsStringSync("2$c,", mode: FileMode.append);
      } else if (board[row][column] is Knight) {
        file.writeAsStringSync("3$c,", mode: FileMode.append);
      } else if (board[row][column] is Rook) {
        file.writeAsStringSync("5$c,", mode: FileMode.append);
      } else if (board[row][column] is Queen) {
        file.writeAsStringSync("9$c,", mode: FileMode.append);
      } else if (board[row][column] is King) {
        file.writeAsStringSync("7$c,", mode: FileMode.append);
      } else {
        file.writeAsStringSync("0$c,", mode: FileMode.append);
      }
    }
    file.writeAsStringSync("\n", mode: FileMode.append);
  }
  final pFile = File('${dir.path}/which_player.txt');
  pFile.writeAsStringSync('');
  if (game.currentPlayer.color == PieceColor.white) {
    pFile.writeAsStringSync("1");
  } else {
    pFile.writeAsStringSync("0");
  }
}
