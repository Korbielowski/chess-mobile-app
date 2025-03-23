// import 'package:chess/pieces.dart';
// // import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter_svg/svg.dart';

// class BoardWidget extends StatefulWidget {
//   const BoardWidget({super.key});

//   @override
//   State<BoardWidget> createState() => Board();
// }

// class Board extends State<BoardWidget> {
//   late GridView gridBoard;
//   late List<List<Piece?>> board;

//   void initBoard() {
//     // 0 - No piece
//     // 1 - Pawn
//     // 2 - Bishop
//     // 3 - Knight
//     // 5 - Rook
//     // 9 - Queen
//     // 10 - King
//     List<List<int>> tmpBoard = [
//       [5, 3, 2, 9, 10, 2, 3, 5],
//       [1, 1, 1, 1, 1, 1, 1, 1],
//       [0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0],
//       [1, 1, 1, 1, 1, 1, 1, 1],
//       [5, 3, 2, 9, 10, 2, 3, 5],
//     ];

//     for (int i = 0; i < 8; i++) {
//       for (int j = 0; j < 8; j++) {
//         int elem = tmpBoard[i][j];
//         Color color = (i > 2) ? Color.white : Color.black;
//         if (elem == 0) {
//           board[i][j] = null;
//         } else if (elem == 1) {
//           board[i][j] = Pawn(i, j, color);
//         } else if (elem == 2) {
//           board[i][j] = Bishop(i, j, color);
//         } else if (elem == 3) {
//           board[i][j] = Knight(i, j, color);
//         } else if (elem == 5) {
//           board[i][j] = Rook(i, j, color);
//         } else if (elem == 9) {
//           board[i][j] = Queen(i, j, color);
//         } else if (elem == 10) {
//           board[i][j] = King(i, j, color);
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chess',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Chess")),
//         body: Container(
//           alignment: Alignment.bottomCenter,
//           child: GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 8,
//             ),
//             itemBuilder: _getBoard,
//             itemCount: 8 * 8,
//           ),
//         ),
//       ),
//     );
//   }

//   Board() {
//     board = List.generate(8, (i) => List.filled(8, null));
//     initBoard();
//     // image = Image.asset("assets/boards/xd.jpg");
//     // image = SvgPicture.asset(
//     //   "assets/boards/normal_chess_board.svg",
//     //   width: width,
//     //   height: height,
//     // );
//   }

//   // GridView initGridBoard() {}

//   Widget _getBoard(BuildContext context, int index) {
//     int x, y = 0;
//     x = (index / 8).floor();
//     y = (index % 8);
//     return GestureDetector(
//       onTap: () => _tileClicked(x, y, context),
//       child: GridTile(
//         child: Container(
//           decoration: BoxDecoration(
//             color: ((x + y) % 2 != 0) ? Colors.brown : Colors.white54,
//             // border: Border.all(color: Colors.black, width: 0.5),
//           ),
//           child: Center(child: board[x][y]?.image),
//         ),
//       ),
//     );
//   }

//   void _tileClicked(int x, int y, BuildContext context) {
//     setState(() {
//       Piece? piece = board[x][y];
//       if (piece == null) {
//         return;
//       }

//       if (piece is Marker) {
//         piece.movePiece(board);
//       } else {
//         piece.showMoves(board);
//       }
//       _clearMarkers();
//       // board[x - 1][y] = piece;
//       // board[x][y] = null;
//     });
//     // print(piece?.column);
//     // if (piece == null) {
//     //   return;
//     // }
//     // piece.showMoves(board);
//   }

//   // GridView drawBoard() {
//   //   return gridBoard;
//   // }

//   void _clearMarkers() {}
// }
