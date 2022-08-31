import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Assets {
  static Widget court() => SvgPicture.asset('assets/images/court.svg');
  static const bluePlayerSprite = 'blue_player_sprite.png';
  static const redPlayerSprite = 'red_player_sprite.png';
}

class AppConstants {
  static const meSpeed = 200.0;
  static const enemySpeed = 130.0;
}
