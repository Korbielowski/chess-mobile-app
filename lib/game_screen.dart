import 'package:chess/model/game.dart';
import 'package:chess/model/piece.dart';
import 'package:chess/riverpod.dart';
import 'package:chess/widgets/circle_widget.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileSize = MediaQuery.of(context).size.width / 8;
    final game = ref.watch(gameProvider);
    return Column(
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
                          ? Image.asset("assets/pieces/black_queen.png")
                          : Image.asset("assets/pieces/white_queen.png"),
                  onPressed: () => {game.promotePawn(1)},
                ),
              ),
              Container(
                color: Colors.grey,
                child: IconButton(
                  icon:
                      (game.promotionPawn?.color == PieceColor.black)
                          ? Image.asset("assets/pieces/black_rook.png")
                          : Image.asset("assets/pieces/white_rook.png"),
                  onPressed: () => {game.promotePawn(2)},
                ),
              ),
              Container(
                color: Colors.grey,
                child: IconButton(
                  icon:
                      (game.promotionPawn?.color == PieceColor.black)
                          ? Image.asset("assets/pieces/black_bishop.png")
                          : Image.asset("assets/pieces/white_bishop.png"),
                  onPressed: () => {game.promotePawn(3)},
                ),
              ),
              Container(
                color: Colors.grey,
                child: IconButton(
                  icon:
                      (game.promotionPawn?.color == PieceColor.black)
                          ? Image.asset("assets/pieces/black_knight.png")
                          : Image.asset("assets/pieces/white_knight.png"),
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
                return _getBoard(context, index, tileSize, game);
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
                          ? Image.asset("assets/pieces/black_queen.png")
                          : Image.asset("assets/pieces/white_queen.png"),
                  onPressed: () => {game.promotePawn(1)},
                ),
              ),
              Container(
                color: Colors.grey,
                child: IconButton(
                  icon:
                      (game.promotionPawn?.color == PieceColor.black)
                          ? Image.asset("assets/pieces/black_rook.png")
                          : Image.asset("assets/pieces/white_rook.png"),
                  onPressed: () => {game.promotePawn(2)},
                ),
              ),
              Container(
                color: Colors.grey,
                child: IconButton(
                  icon:
                      (game.promotionPawn?.color == PieceColor.black)
                          ? Image.asset("assets/pieces/black_bishop.png")
                          : Image.asset("assets/pieces/white_bishop.png"),
                  onPressed: () => {game.promotePawn(3)},
                ),
              ),
              Container(
                color: Colors.grey,
                child: IconButton(
                  icon:
                      (game.promotionPawn?.color == PieceColor.black)
                          ? Image.asset("assets/pieces/black_knight.png")
                          : Image.asset("assets/pieces/white_knight.png"),
                  onPressed: () => {game.promotePawn(4)},
                ),
              ),
            ],
          ),
      ],
    );
  }
}

Widget _getBoard(BuildContext context, int index, double tileSize, Game game) {
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
              color: ((row + column) % 2 != 0) ? Colors.brown : Colors.white,
              // border: Border.all(color: Colors.black, width: 0.5),
            ),
            child:
                (game.board.board[row][column] is! NoPiece)
                    ? Center(child: game.board.board[row][column].image)
                    : null,
          ),
          CircleWidget(row, column),
        ],
      ),
    ),
  );
}
