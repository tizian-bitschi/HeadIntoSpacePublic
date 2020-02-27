import 'dart:ui';
import 'dart:math' as math;
import 'dart:developer' as console;

import 'package:flame/sprite.dart';
import 'package:head_into_space/Bullet.dart';
import 'package:head_into_space/Bullets/FriendlyLaser.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:sensors/sensors.dart';

class Player {
  final GameEngine game;

  double health = 100;
  double speed = 2;
  double toX = 0;
  double toY = 0;
  double shootSpeed = 25;
  double shootCooldown = 0;

  Rect playerRect;

  Sprite playerSprite;

  Player(this.game, double x, double y) {
    this.playerRect =
        Rect.fromLTWH(x, y, this.game.tileSize, this.game.tileSize);

    this.playerSprite = Sprite('playerShip1_blue.png');
  }

  void render(Canvas c) {
    this.playerSprite.renderRect(c, this.playerRect);
  }

  void update(double t) {
    if (this.shootCooldown > this.shootSpeed) {
      this.game.bullets.add(FriendlyLaser(
          this.game,
          this.playerRect.left,
          this.playerRect.top));
      this.shootCooldown = 0;
    }

    double tempX = this.game.tileSize * this.toX * t * this.speed;
    double tempY = this.game.tileSize * this.toY * t * this.speed;
    math.Point<double> tempDir = math.Point<double>(tempX, tempY);

    this.playerRect = this.playerRect.translate(tempDir.x, tempDir.y);
    this.shootCooldown++;
  }

  void onDamage(Bullet b) {
    this.health -= b.damage;
    console.log("Health: " + this.health.toString());
  }

  void move(math.Point<double> d) {
    this.toX = d.x;

    this.toY = d.y;
  }
}
