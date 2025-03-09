import 'package:chess/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: GrandChess()));
}

class GrandChess extends ConsumerWidget {
  const GrandChess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Grand Chess",
      theme: ThemeData(colorScheme: ColorScheme.dark(), useMaterial3: true),
      home: const GameScreen(),
    );
  }
}
