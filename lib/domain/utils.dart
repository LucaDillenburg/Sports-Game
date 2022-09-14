import 'dart:math';

import 'package:flame/extensions.dart';

enum Direction {
  up,
  upRight,
  right,
  downRight,
  down,
  downLeft,
  left,
  upLeft,
}

double offsetAngle(Offset offset) {
  final angleCos = acos(offset.dx / offset.distance);
  final angle = offset.dy < 0 ? 2 * pi - angleCos : angleCos;
  return angle;
}

extension DirectionUtils on Direction {
  static Direction from(Offset offset) {
    final angle = offsetAngle(offset) * 180 / pi;
    final amountStops = (angle / (360 / Direction.values.length)).round();
    switch (amountStops) {
      case 0:
      case 8:
        return Direction.right;
      case 1:
        return Direction.upRight;
      case 2:
        return Direction.up;
      case 3:
        return Direction.upLeft;
      case 4:
        return Direction.left;
      case 5:
        return Direction.downLeft;
      case 6:
        return Direction.down;
      case 7:
        return Direction.downRight;
      default:
        throw Exception('Unknown amountStops: $amountStops');
    }
  }

  Vector2 multiply(double delta) {
    const sin45 = 0.70710678118;

    switch (this) {
      case Direction.up:
        return Vector2(0, -delta);
      case Direction.down:
        return Vector2(0, delta);
      case Direction.left:
        return Vector2(-delta, 0);
      case Direction.right:
        return Vector2(delta, 0);
      case Direction.upRight:
        return Vector2(sin45 * delta, -sin45 * delta);
      case Direction.downRight:
        return Vector2(sin45 * delta, sin45 * delta);
      case Direction.downLeft:
        return Vector2(-sin45 * delta, sin45 * delta);
      case Direction.upLeft:
        return Vector2(-sin45 * delta, -sin45 * delta);
    }
  }
}

extension OffsetExtensions on Offset {
  Vector2 toVector2() => Vector2(dx, dy);
  bool get isZero => dx == 0 && dy == 0;
}
