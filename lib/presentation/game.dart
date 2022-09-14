import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../domain/intelligence.dart';
import '../domain/utils.dart';
import '../theme.dart';
import 'widgets/components.dart';
import 'widgets/controls.dart';
import 'widgets/player.dart';

class MainGamePage extends StatefulWidget {
  const MainGamePage({Key? key}) : super(key: key);

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGamePage> {
  final game = SportsGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20) +
                EdgeInsets.only(
                  left: MediaQuery.of(context).padding.left,
                  right: MediaQuery.of(context).padding.right,
                ),
            color: AppColors.of(context).primary,
            child: Center(
              child: AspectRatio(
                aspectRatio: 2,
                child: GameWidget(
                  game: game,
                  backgroundBuilder: (context) => Assets.court(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(32.0).copyWith(
                right: MediaQuery.of(context).padding.right == 0
                    ? null
                    : MediaQuery.of(context).padding.right + 10,
              ),
              child: GameButton(
                name: 'P',
                size: 100,
                onTap: game.onPass,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(32.0).copyWith(
                left: MediaQuery.of(context).padding.left == 0
                    ? null
                    : MediaQuery.of(context).padding.left + 10,
              ),
              child: Joypad(onChanged: game.onJoypadChanged),
            ),
          ),
        ],
      ),
    );
  }
}

class SportsGame extends FlameGame with HasCollisionDetection {
  late final me = MePlayer(selected: false)
    ..position = size / 2 - Vector2(50, 0)
    ..hasBall = true;
  late final enemy = EnemyPlayer()
    ..position = size / 2 - Vector2(-size.x * 0.25, 0)
    ..angle = pi;
  final ball = Ball();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(me);
    add(enemy);
  }

  @override
  void update(double delta) {
    super.update(delta);
    enemy.walk(me.position);
  }

  var _joypadOffset = Offset(1, 0);
  void onJoypadChanged(Offset offset) {
    if (!offset.isZero) {
      _joypadOffset = offset;
    }
    me.updateWalkDirection(offset);
  }

  static const _maxForceDurationMs = 400;
  void onPass(Duration durationPressed) {
    if (true) {
      // TODO: !_joypadOffset.isZero && me.hasBall) {
      me.hasBall = false;
      final direction = _joypadOffset / _joypadOffset.distanceSquared;
      final forcePerc =
          min(1.0, durationPressed.inMilliseconds / _maxForceDurationMs);
      final directionSpeed = direction * forcePerc * AppConstants.ballSpeed;
      add(
        ball
          ..center = me.center
          ..route = BallRoute(
            directionSpeed: directionSpeed,
            forcePerc: forcePerc,
            from: me.center.toOffset(),
          ),
      );
    }
  }
}
