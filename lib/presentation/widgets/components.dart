import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../../domain/config.dart';

class Ball extends SpriteAnimationComponent with HasGameRef {
  Ball() : super(size: Vector2(20, 20)) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final spriteInfo = Assets.ballSprite(bouncing: true);
    final sprite = await Flame.images.load(spriteInfo.path);
    animation = SpriteAnimation.fromFrameData(sprite, spriteInfo.animationData);
  }

  @override
  void update(double delta) {
    super.update(delta);

    // final offset = Vector2(walkX, walkY);
    // if (!offset.isZero()) {
    //   center.add(offset * sqrt(delta));
    //   angle = offsetAngle(_offset);
    //   changeAnimation(walking: true);
    // } else {
    //   changeAnimation(walking: false);
    // }
  }
}
