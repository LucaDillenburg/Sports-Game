import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../../domain/config.dart';
import '../../domain/intelligence.dart';
import '../../domain/utils.dart';
import '../../theme.dart';

class MePlayer extends Player {
  MePlayer({required bool selected})
      : super(selected: selected, isEnemy: false);

  void updateWalkDirection(Offset offset) {
    _offset = offset * AppConstants.meSpeed;
    print('offset player: $offset | _offset: $_offset');
  }
}

class EnemyPlayer extends Player {
  EnemyPlayer() : super(selected: false, isEnemy: true);

  final enemyIntelligence = EnemyIntelligence();

  void walk(Vector2 user) {
    _offset = enemyIntelligence.walk(user.toOffset(), position.toOffset()) *
        AppConstants.enemySpeed;
  }
}

class Player extends SpriteAnimationComponent with HasGameRef {
  Player({required this.selected, required this.isEnemy})
      : super(size: Vector2(_size, _size)) {
    anchor = Anchor.center;
  }

  late final sprite = Flame.images.load(
    isEnemy ? Assets.redPlayerSprite : Assets.bluePlayerSprite,
  );

  static final _textureSize = Vector2(140, 140);
  static const _size = 40.0;

  final bool isEnemy;
  final bool selected;

  Offset _offset = Offset(0, 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = gameRef.size / 2;
    await changeAnimation(walking: false);
  }

  bool? _walkingAnimation;
  Future<void> changeAnimation({required bool walking}) async {
    if (_walkingAnimation == walking) return;
    _walkingAnimation = walking;

    if (walking) {
      animation = SpriteAnimation.fromFrameData(
        await sprite,
        SpriteAnimationData.range(
          start: 1,
          end: 2,
          amount: 3,
          stepTimes: [0.2, 0.2],
          textureSize: _textureSize,
        ),
      );
    } else {
      animation = SpriteAnimation.fromFrameData(
        await sprite,
        SpriteAnimationData.range(
          start: 0,
          end: 0,
          amount: 3,
          stepTimes: [1],
          textureSize: _textureSize,
        ),
      );
    }
  }

  @override
  void render(Canvas c) {
    if (selected) {
      final color = Paint()
        ..color =
            ColorTween(begin: appColors.tertiary, end: Colors.white).lerp(0.5)!
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;
      c.drawCircle(Offset(size.x / 2, size.y / 2), _size * 0.7, color);
    }

    super.render(c);
  }

  @override
  void update(double delta) {
    super.update(delta);

    if (!isEnemy) print('_offset walk: $_offset');

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
