import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n11game/ember_quest.dart';

enum Direction { left, right, none }

class GameControls extends StatelessWidget {
  final EmberQuestGame game;

  const GameControls({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Joystick for movement
        Positioned(
          bottom: 50,
          left: 20,
          child: Joystick(
            onDirectionChanged: (direction) {
              switch (direction) {
                case Direction.left:
                  game.movePlayer(Direction.left);
                  break;
                case Direction.right:
                  game.movePlayer(Direction.right);
                  break;
                case Direction.none:
                  game.stopPlayer();
                  break;
              }
            },
          ),
        ),
        // Jump button
        Positioned(
          bottom: 50,
          right: 20,
          child: GestureDetector(
            onTap: () => game.jumpPlayer(),
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
              ),
              child: const Icon(Icons.arrow_upward),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 90,
          child: ElevatedButton(
            onPressed: () {
              game.fireWeapon();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.red,
            ),
            child: const Text(
              "\u2022",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Joystick extends StatefulWidget {
  final Function(Direction) onDirectionChanged;

  const Joystick({super.key, required this.onDirectionChanged});

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset _startPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _startPosition = details.localPosition;
          _currentPosition = _startPosition;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _currentPosition = details.localPosition;
        });

        final offset = _currentPosition - _startPosition;
        final direction = offset.dx < -10
            ? Direction.left
            : offset.dx > 10
                ? Direction.right
                : Direction.none;

        widget.onDirectionChanged(direction);
      },
      onPanEnd: (details) {
        setState(() {
          _currentPosition = _startPosition;
        });

        widget.onDirectionChanged(Direction.none);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.5),
        ),
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent,
            ),
            child: Center(
              child: Transform.translate(
                offset: _currentPosition - _startPosition,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
