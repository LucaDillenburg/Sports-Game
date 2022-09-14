import 'dart:math';

import 'package:flame/extensions.dart';

class EnemyIntelligence {
  Offset walk(Offset user, Offset enemy) {
    final direction = user - enemy;
    if (direction.distance <= 5) return Offset(0, 0);
    return direction / direction.distance;
  }
}

class WalkBoundaries {
  final Offset size;
  WalkBoundaries({required this.size});

  Offset walkInside({required Offset center, required Offset walkIntent}) {
    return Offset(
      _walkX(center, walkIntent),
      _walkY(center, walkIntent),
    );
  }

  double _walkX(Offset center, Offset walkIntent) {
    if (center.dx + walkIntent.dx < 0) {
      return -center.dx;
    }
    if (center.dx + walkIntent.dx > size.dx) {
      return size.dx - center.dx;
    }
    return walkIntent.dx;
  }

  double _walkY(Offset center, Offset walkIntent) {
    if (center.dy + walkIntent.dy < 0) {
      return -center.dy;
    }
    if (center.dy + walkIntent.dy > size.dy) {
      return size.dy - center.dy;
    }
    return walkIntent.dy;
  }
}

class BallRoute {
  final Offset from;
  final Offset directionSpeed;
  final double forcePerc;
  BallRoute({
    required this.from,
    required this.directionSpeed,
    required this.forcePerc,
  }) : _xy = from;

  double _delta = 0;
  Offset _xy;
  void increaseDelta(double v) {
    if (isStationary) return;

    _delta += v;
    _checkBounce();
    if (_isBouncing) {
      _xy += directionSpeed * _sinFunc();
    } else if (!isStationary) {
      _xy += directionSpeed * forcePercWithBounces;
    }
  }

  int _bounces = 0;
  double _lastFuncValue = 0;
  bool _increasing = true;
  void _checkBounce() {
    final curIncreasing = _sinFunc() > _lastFuncValue;
    if (!_increasing && curIncreasing) {
      _bounces++;
    }
    _lastFuncValue = _sinFunc();
    _increasing = curIncreasing;
  }

  double get forcePercWithBounces {
    final c = forcePerc / (_bounces + 1);
    return c;
  }

  bool get _isBouncing => forcePercWithBounces >= 0.3;
  bool get isStationary => forcePercWithBounces < 0.15;

  double get z => !_isBouncing ? 0 : forcePercWithBounces * _sinFunc();
  Offset get xy => _xy;

  double _sinFunc() {
    final a = forcePercWithBounces; // proportional to maximum
    final b = 4 + 4 * (1 - forcePercWithBounces);
    // inversely proportional to period (time in the air and distance)
    final c = pi / 2; // changes first value
    return (a * sin(b * _delta - c) + a) / 2;
  }
}

class Parabola {
  final double a;
  final double b;
  final double c;
  Parabola(this.a, this.b, this.c);

  double calc(double x) {
    return -b + sqrt(b * b - 4 * a * c) / 2 * a;
  }
}
