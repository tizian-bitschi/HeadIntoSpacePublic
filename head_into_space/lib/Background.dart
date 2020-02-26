import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:head_into_space/GameEngine.dart';

class Background {
  final GameEngine game;

  Sprite backgroundSprite;

  Rect backgroundRect;

  Background(this.game) {
    this.backgroundSprite = Sprite('NebulaBlue.png');
    this.backgroundRect = Rect.fromLTWH(0, this.game.screenSize.height - (this.game.tileSize * 34), this.game.tileSize * 9, this.game.tileSize * 34);
  }

  void render(Canvas c) {
    this.backgroundSprite.renderRect(c, this.backgroundRect);
  }

  void update(double t) {

  }
}