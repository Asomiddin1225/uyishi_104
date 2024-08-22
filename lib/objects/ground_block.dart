import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../ember_quest.dart';
import '../managers/segment_manager.dart';

class GroundBlock extends SpriteComponent
    with HasGameReference<EmberQuestGame> {
  final Vector2 gridPosition;
  double xOffset;

  final UniqueKey _blockKey = UniqueKey();
  final Vector2 velocity = Vector2.zero();

  GroundBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(32), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    final groundImage = game.images.fromCache('ground.png');
    sprite = Sprite(groundImage);
    position = Vector2(
      gridPosition.x * size.x + xOffset,
      game.size.y - gridPosition.y * size.y,
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));

    // Mark the last block position
    if (gridPosition.x == 9 && position.x > game.lastBlockXPosition) {
      game.lastBlockKey = _blockKey;
      game.lastBlockXPosition = position.x + size.x;
    }
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;

    // Remove the block if it moves out of the screen
    if (position.x < -size.x) {
      removeFromParent();

      // Add a new segment after removing the first block of the previous segment
      if (gridPosition.x == 0) {
        double newXPosition = game.lastBlockXPosition;

        // Generate a random gap size between 1 and 4 blocks
        final gapSize = Random().nextInt(4) + 1;

        // Set the new position with the gap
        newXPosition += size.x * gapSize;

        // Ensure that the new segment doesn't have a gap larger than 4 blocks
        if (newXPosition > game.lastBlockXPosition + size.x * 4) {
          newXPosition = game.lastBlockXPosition + size.x * 4;
        }

        int nextSegmentIndex = Random().nextInt(segments.length);
        game.loadGameSegments(nextSegmentIndex, newXPosition);
      }
    }

    // Update the last block position tracking
    if (gridPosition.x == 9) {
      if (game.lastBlockKey == _blockKey) {
        game.lastBlockXPosition = position.x + size.x + 10;
      }
    }

    // Remove the block if the player's health is 0
    if (game.health <= 0) {
      removeFromParent();
    }

    super.update(dt);
  }
}
