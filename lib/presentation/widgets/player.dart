import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../../domain/intelligence.dart';
import '../../domain/utils.dart';
import '../../theme.dart';
import 'components.dart';

class MePlayer extends Player {
  MePlayer({required bool selected})
      : super(selected: selected, isEnemy: false);

  void updateWalkDirection(Offset offset) {
    _walkIntent = offset * AppConstants.meSpeed;
  }
}

class EnemyPlayer extends Player {
  EnemyPlayer() : super(selected: false, isEnemy: true);

  final enemyIntelligence = EnemyIntelligence();

  void walk(Vector2 user) {
    _walkIntent = enemyIntelligence.walk(user.toOffset(), position.toOffset()) *
        AppConstants.enemySpeed;
  }
}

class Player extends SpriteAnimationComponent with HasGameRef {
  Player({required this.selected, required this.isEnemy})
      : super(size: Vector2(40, 40)) {
    anchor = Anchor.center;
  }

  late final ball = Ball()..center = Vector2(size.x / 2 + 20, size.y / 2);
  final bool isEnemy;
  final bool selected;

  Offset _walkIntent = Offset(0, 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await changeAnimation(walking: false);
  }

  bool _hasBall = false;
  bool get hasBall => _hasBall;
  set hasBall(bool hasBall) {
    if (_hasBall == hasBall) return;
    _hasBall = hasBall;
    if (hasBall) {
      add(ball);
    } else {
      remove(ball);
    }
  }

  bool? _walkingAnimation;
  Future<void> changeAnimation({required bool walking}) async {
    if (_walkingAnimation == walking) return;
    _walkingAnimation = walking;

    final spriteInfo = Assets.playerSprite(blue: !isEnemy, walking: walking);
    final sprite = await Flame.images.load(spriteInfo.path);
    animation = SpriteAnimation.fromFrameData(sprite, spriteInfo.animationData);
  }

  @override
  void render(Canvas c) {
    if (selected) {
      final color = Paint()
        ..color =
            ColorTween(begin: appColors.tertiary, end: Colors.white).lerp(0.5)!
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;
      c.drawCircle(Offset(size.x / 2, size.y / 2), size.x * 0.7, color);
    }

    super.render(c);
  }

  late final courtBoundaries =
      WalkBoundaries(size: Offset(gameRef.size.x, gameRef.size.y));
  @override
  void update(double delta) {
    super.update(delta);

    final canWalk = courtBoundaries
        .walkInside(
          center: center.toOffset(),
          walkIntent: _walkIntent,
        )
        .toVector2();
    if (!canWalk.isZero()) {
      center.add(canWalk * sqrt(delta));
      angle = offsetAngle(_walkIntent);
      changeAnimation(walking: true);
    } else {
      changeAnimation(walking: false);
    }
  }
}
