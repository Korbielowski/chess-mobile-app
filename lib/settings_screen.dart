import 'package:chess/game_screen.dart';
import 'package:chess/model/game.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  Color lightPiecesColor = Colors.white;
  Color darkPiecesColor = Colors.black;
  Color lightSquaresColor = Colors.white;
  Color darkSquaresColor = Colors.brown;
  Game game;

  SettingsScreen({
    super.key,
    required this.lightPiecesColor,
    required this.darkPiecesColor,
    required this.lightSquaresColor,
    required this.darkSquaresColor,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        child: const Text(style: TextStyle(color: Colors.black), 'Go to board'),
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
      body: Column(
        children: [
          Container(
            color: Colors.grey,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    lightSquaresColor = Colors.white;
                    darkSquaresColor = Colors.brown;
                  },
                  child: Text("Default"),
                ),
                ColoredBox(
                  color: Colors.white,
                  child: SizedBox(width: 20, height: 20),
                ),
                ColoredBox(
                  color: Colors.brown,
                  child: SizedBox(width: 20, height: 20),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    lightSquaresColor = Colors.white;
                    darkSquaresColor = Colors.lightGreen;
                  },
                  child: Text("Template 1"),
                ),
                ColoredBox(
                  color: Colors.white,
                  child: SizedBox(width: 20, height: 20),
                ),
                ColoredBox(
                  color: Colors.lightGreen,
                  child: SizedBox(width: 20, height: 20),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    lightSquaresColor = Colors.greenAccent;
                    darkSquaresColor = Colors.red;
                  },
                  child: Text("Template 2"),
                ),
                ColoredBox(
                  color: Colors.greenAccent,
                  child: SizedBox(width: 20, height: 20),
                ),
                ColoredBox(
                  color: Colors.red,
                  child: SizedBox(width: 20, height: 20),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    lightSquaresColor = Colors.lightBlue;
                    darkSquaresColor = Colors.blueAccent;
                  },
                  child: Text("Template 3"),
                ),
                ColoredBox(
                  color: Colors.lightBlue,
                  child: SizedBox(width: 20, height: 20),
                ),
                ColoredBox(
                  color: Colors.blueAccent,
                  child: SizedBox(width: 20, height: 20),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    game.updatePieceAssets("normal_pieces");
                  },
                  child: Text("Default pieces"),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    game.updatePieceAssets("fairy_pieces");
                  },
                  child: Text("Fairy pieces"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
