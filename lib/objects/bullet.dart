import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/collisions.dart';
import 'package:n11game/objects/objects.dart';
import '../ember_quest.dart';

class BulletWeapon extends SpriteAnimationComponent
    with HasGameReference<EmberQuestGame>, CollisionCallbacks {
  final Vector2 initialPosition;
  final Vector2 direction;
  double speed;

  BulletWeapon({
    required this.initialPosition,
    required this.direction,
    this.speed = 500.0, // Harakat tezligini sozlash
  }) : super(size: Vector2.all(16), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('bullet.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.1,
      ),
    );

    position = initialPosition;

    // Hitting
    add(RectangleHitbox(collisionType: CollisionType.passive));
    add(CircleHitbox());
    // Movement
    add(
      MoveEffect.by(
        direction * speed * 4,
        EffectController(
          duration: 3,
          alternate: false,
        ),
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlatformBlock) {
      // Handle collision with FireWeapon
      removeFromParent(); // Remove the FireWeapon
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (position.x < 0 ||
        position.x > game.size.x ||
        position.y < 0 ||
        position.y > game.size.y) {
      removeFromParent();
    }
  }
}
