import 'dart:ui';
import 'package:head_into_space/GameEngine.dart';

class EnemyShooter {
  final GameEngine game;

  Rect enemyShooter;

  Paint enemyShooterPaint;

  EnemyShooter(this.game, double x, double y) {
    this.enemyShooter = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    this.enemyShooterPaint = Paint();
    this.enemyShooterPaint.color = Color(0xff6ab04c);
  }

  void render(Canvas c) {
    c.drawRect(this.enemyShooter, this.enemyShooterPaint);
  }

  void update(double t) {

  }
}