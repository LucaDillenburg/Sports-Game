import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum BallState { bouncing, spinning, stationary }

class Assets {
  static Widget court() => SvgPicture.asset('assets/images/court.svg');

  static SpriteInfo playerSprite({required bool blue, required bool walking}) =>
      SpriteInfo(
        path: blue ? 'blue_player_sprite.png' : 'red_player_sprite.png',
        animationData: SpriteAnimationData.range(
          amount: 3,
          start: walking ? 1 : 0,
          end: walking ? 2 : 0,
          textureSize: Vector2(140, 140),
          stepTimes: walking ? [0.2, 0.2] : [1],
        ),
      );

  static SpriteInfo ballSprite({required BallState state}) {
    final textureSize = Vector2(140, 140);
    switch (state) {
      case BallState.bouncing:
        return SpriteInfo(
          path: 'bouncing_ball_sprite.png',
          animationData: SpriteAnimationData.range(
            amount: 2,
            start: 0,
            end: 1,
            textureSize: textureSize,
            stepTimes: [0.15, 0.15],
          ),
        );
      case BallState.spinning:
        return SpriteInfo(
          path: 'spinning_ball_sprite.png',
          animationData: SpriteAnimationData.range(
            amount: 2,
            start: 0,
            end: 1,
            textureSize: textureSize,
            stepTimes: [0.1, 0.1],
          ),
        );
      case BallState.stationary:
        return SpriteInfo(
          path: 'bouncing_ball_sprite.png',
          animationData: SpriteAnimationData.range(
            amount: 2,
            start: 0,
            end: 0,
            textureSize: textureSize,
            stepTimes: [1],
          ),
        );
    }
  }
}

class SpriteInfo {
  final String path;
  final SpriteAnimationData animationData;

  SpriteInfo({
    required this.path,
    required this.animationData,
  });
}

class AppConstants {
  static const meSpeed = 30.0;
  static const enemySpeed = 22.0;
  static const ballSpeed = 2.5;
}
