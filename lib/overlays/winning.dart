import 'package:flutter/material.dart';
import '../ember_quest.dart';

class YouWin extends StatelessWidget {
  final EmberQuestGame game;

  const YouWin({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You Win!',
            style: TextStyle(fontSize: 48, color: Colors.white),
          ),
          ElevatedButton(
            onPressed: () {
              game.reset();
              game.overlays.remove('YouWin');
              game.resumeEngine();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
