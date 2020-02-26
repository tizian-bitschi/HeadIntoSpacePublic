import 'dart:ui';
import 'package:head_into_space/GameEngine.dart';

class EnemyShooter {
  final GameEngine game;

  bool isDead = false;
  bool isOffScreen = false;

  Rect enemyShooterRect;

  Paint enemyShooterPaint;

  EnemyShooter(this.game, double x, double y) {
    this.enemyShooterRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    this.enemyShooterPaint = Paint();
    this.enemyShooterPaint.color = Color(0xff6ab04c);
  }

  void render(Canvas c) {
    c.drawRect(this.enemyShooterRect, this.enemyShooterPaint);
  }

  void update(double t) {
    if (this.enemyShooterRect.top > this.game.screenSize.height) {
      this.isOffScreen = true;
    }

    if (this.isDead) {
      this.enemyShooterRect = this.enemyShooterRect.translate(0, this.game.tileSize * 12 * t);
    }

    if (this.isOffScreen) {

    }
  }

  void onTapDown() {
    this.isDead = true;
    this.enemyShooterPaint.color = Color(0xffff4757);
    this.game.spawnEnemyShooter();
  }
}