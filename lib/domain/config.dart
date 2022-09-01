import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  static SpriteInfo ballSprite({required bool bouncing}) => SpriteInfo(
        path:
            bouncing ? 'bouncing_ball_sprite.png' : 'spinning_ball_sprite.png',
        animationData: SpriteAnimationData.range(
          amount: 2,
          start: 0,
          end: 1,
          textureSize: Vector2(140, 140),
          stepTimes: [0.15, 0.15],
        ),
      );
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
}
