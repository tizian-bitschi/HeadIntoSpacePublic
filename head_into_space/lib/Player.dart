import 'dart:ui';
import 'dart:developer' as console;

import 'package:flame/sprite.dart';
import 'package:head_into_space/GameEngine.dart';

class Player {
  final GameEngine game;

  double health = 100;

  Rect playerRect;

  Sprite playerSprite;

  Player(this.game, double x, double y) {
    console.log("Spawning at X:" + x.toString() + ", Y: " + y.toString());
    this.playerRect = Rect.fromLTWH(x, y, this.game.tileSize, this.game.tileSize);

    this.playerSprite = Sprite('playerShip1_blue.png');
  }

  void render(Canvas c) {
    this.playerSprite.renderRect(c, this.playerRect);
  }

  void update(double t) {

  }
}