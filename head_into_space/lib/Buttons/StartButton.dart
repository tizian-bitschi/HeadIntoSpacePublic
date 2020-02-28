import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';
import 'package:head_into_space/GameEngine.dart';

class StartButton {
  final GameEngine game;

  Rect buttonRect;

  Sprite buttonSprite;

  StartButton(this.game) {
    this.buttonRect = Rect.fromLTWH((this.game.screenSize.width - 222) / 2,
        (3 * this.game.screenSize.height / 4) - (39 / 2), 222, 39);
    this.buttonSprite = Sprite('UI/startButton.png');
  }

  void render(Canvas c) {
    this.buttonSprite.renderRect(c, this.buttonRect);
  }

  void update(double t) {}
}
