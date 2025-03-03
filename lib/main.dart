import 'package:chess/board.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BoardWidget());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Board board = Board();

//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Chess")),
//         body: Container(
//           alignment: Alignment.bottomCenter,
//           child: board.build(),
//         ),
//       ),
//     );
//   }
// }
