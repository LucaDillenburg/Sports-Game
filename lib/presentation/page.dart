import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../domain/config.dart';
import 'game.dart';
import 'widgets/joystick.dart';
import '../theme.dart';

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
                  backgroundBuilder: (context) =>
                      Expanded(child: Assets.court()),
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
              child: Joypad(onChanged: game.onJoypadChanged),
            ),
          )
        ],
      ),
    );
  }
}
