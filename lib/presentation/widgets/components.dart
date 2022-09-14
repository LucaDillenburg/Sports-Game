import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../../config.dart';
import '../../domain/intelligence.dart';
import '../../domain/utils.dart';

const _ballSize = 20.0;

class Ball extends SpriteAnimationComponent with HasGameRef {
  Ball() : super(size: Vector2(_ballSize, _ballSize)) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _checkChangeAnimation();
  }

  @override
  void update(double delta) {
    super.update(delta);

    final route = this.route;
    if (route != null) {
      route.increaseDelta(delta);
      final sizeIncrease = 1 + 0.5 * route.z;
      final diameter = _ballSize * sizeIncrease;
      size = Vector2(diameter, diameter);
      center = route.xy.toVector2();
    }
    _checkChangeAnimation();
  }

  BallRoute? route;

  Future<void> _checkChangeAnimation() {
    late final BallState state;
    final route = this.route;
    if (route == null) {
      state = BallState.bouncing;
    } else {
      if (route.isStationary) {
        state = BallState.stationary;
      } else {
        state = BallState.spinning;
      }
    }

    return _changeAnimation(state);
  }

  BallState? _lastState;
  Future<void> _changeAnimation(BallState state) async {
    if (_lastState == state) return;
    _lastState = state;

    final spriteInfo = Assets.ballSprite(state: state);
    final sprite = await Flame.images.load(spriteInfo.path);
    animation = SpriteAnimation.fromFrameData(sprite, spriteInfo.animationData);
  }
}
