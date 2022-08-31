import 'package:flame/extensions.dart';

class EnemyIntelligence {
  Offset walk(Offset user, Offset enemy) {
    final direction = user - enemy;
    if (direction.distance <= 5) return Offset(0, 0);
    return direction / direction.distance;
  }
}
