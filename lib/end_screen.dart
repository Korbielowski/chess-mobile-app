import 'package:chess/game_screen.dart';
import 'package:flutter/material.dart';

class EndScreen extends StatelessWidget {
  Color lightPiecesColor = Colors.white;
  Color darkPiecesColor = Colors.black;
  Color lightSquaresColor = Colors.white;
  Color darkSquaresColor = Colors.brown;
  final String message;

  EndScreen({
    super.key,
    required this.lightPiecesColor,
    required this.darkPiecesColor,
    required this.lightSquaresColor,
    required this.darkSquaresColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text(
                'New Game',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => GameScreen(
                          lightPiecesColor: lightPiecesColor,
                          darkPiecesColor: darkPiecesColor,
                          lightSquaresColor: lightSquaresColor,
                          darkSquaresColor: darkSquaresColor,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
