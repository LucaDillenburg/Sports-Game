import 'dart:math';

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

  static final _textureSize = Vector2(140, 140);
  static const _size = 40.0;

  final bool isEnemy;
  final bool selected;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    position = gameRef.size / 2;

    final assetPath =
        isEnemy ? Assets.redPlayerSprite : Assets.bluePlayerSprite;
    final sprite = await Flame.images.load(assetPath);
    animation = SpriteAnimation.fromFrameData(
      sprite,
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: 0.2,
        textureSize: _textureSize,
      ),
    );
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

  var _offset = Offset(0, 0);

  @override
  void update(double delta) {
    super.update(delta);

    // TODO: fixed directions
    // final direction = DirectionUtils.from(offset.dx, offset.dy);
    // _offset = direction.multiply(offset.distance * _speed);

    final offset = Vector2(walkX, walkY);
    if (!offset.isZero()) {
      position.add(offset * delta);
      angle = offsetAngle(Offset(offset.x, offset.y));
    }
  }

  double get walkX {
    if (position.x + _offset.dx < 0) {
      return -position.x;
    }
    if (position.x + _offset.dx + size.x > gameRef.size.x) {
      return gameRef.size.x - (position.x + size.x);
    }
    return _offset.dx;
  }

  double get walkY {
    if (position.y + _offset.dy < 0) {
      return -position.y;
    }
    if (position.y + _offset.dy + size.y > gameRef.size.y) {
      return gameRef.size.y - (position.y + size.y);
    }
    return _offset.dy;
  }
}
