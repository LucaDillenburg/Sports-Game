import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../../domain/config.dart';
import '../../domain/intelligence.dart';
import '../../domain/utils.dart';
import '../../theme.dart';
import 'components.dart';

class MePlayer extends Player {
  MePlayer({required bool selected})
      : super(selected: selected, isEnemy: false, hasBall: true);

  void updateWalkDirection(Offset offset) {
    _offset = offset * AppConstants.meSpeed;
  }
}

class EnemyPlayer extends Player {
  EnemyPlayer() : super(selected: false, isEnemy: true, hasBall: false);

  final enemyIntelligence = EnemyIntelligence();

  void walk(Vector2 user) {
    _offset = enemyIntelligence.walk(user.toOffset(), position.toOffset()) *
        AppConstants.enemySpeed;
  }
}

class Player extends SpriteAnimationComponent with HasGameRef {
  Player({required this.selected, required this.isEnemy, required this.hasBall})
      : super(size: Vector2(40, 40)) {
    anchor = Anchor.center;
  }

  final bool isEnemy;
  final bool selected;

  Offset _offset = Offset(0, 0);
  bool hasBall;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await changeAnimation(walking: false);
    if (hasBall) {
      add(Ball()..center = Vector2(size.x / 2 + 20, size.y / 2));
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

  @override
  void update(double delta) {
    super.update(delta);

    final offset = Vector2(walkX, walkY);
    if (!offset.isZero()) {
      center.add(offset * sqrt(delta));
      angle = offsetAngle(_offset);
      changeAnimation(walking: true);
    } else {
      changeAnimation(walking: false);
    }
  }

  double get walkX {
    if (center.x + _offset.dx < 0) {
      return -center.x;
    }
    if (center.x + _offset.dx > gameRef.size.x) {
      return gameRef.size.x - center.x;
    }
    return _offset.dx;
  }

  double get walkY {
    if (center.y + _offset.dy < 0) {
      return -center.y;
    }
    if (center.y + _offset.dy > gameRef.size.y) {
      return gameRef.size.y - center.y;
    }
    return _offset.dy;
  }
}
