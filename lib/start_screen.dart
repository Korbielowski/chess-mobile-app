import 'package:chess/game_screen.dart';
import 'package:chess/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text(style: TextStyle(color: Colors.black), 'Load Game'),
          onPressed: () {
            game.loadBoard();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text(style: TextStyle(color: Colors.black), 'New Game'),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
        ),
      ],
    );
  }
}
