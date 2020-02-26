import 'dart:ui';
import 'dart:developer' as console;
import 'package:head_into_space/GameEngine.dart';
import 'package:flame/sprite.dart';

class Bullet {
  final GameEngine game;

  bool toDestroy = false;
  bool friendly;

  double bulletSpeed;
  double bulletDirection;
  double damage;

  Rect bulletRect;

  Sprite bulletSprite;

  Bullet(this.game, double x, double y) {
    this.bulletRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
  }

  void render(Canvas c) {
    this.bulletSprite.renderRect(c, this.bulletRect);
  }

  void update(double t) {
    this.bulletRect = this.bulletRect.translate(0, this.game.tileSize * this.bulletSpeed * t * this.bulletDirection);

    if (this.bulletRect.bottom < 0) {
      this.toDestroy = true;
    }
  }

  void destroy() {
    this.toDestroy = true;
  }
}