import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'widgets/player.dart';

/// This class encapulates the whole game.
class SportsGame extends FlameGame {
  final me = MePlayer(selected: false);
  final enemy = EnemyPlayer();

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

  void onJoypadChanged(Offset offset) {
    me.updateWalkDirection(offset);
  }
}
