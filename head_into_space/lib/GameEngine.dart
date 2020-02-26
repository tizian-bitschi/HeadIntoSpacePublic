import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:head_into_space/EnemyShooter.dart';

class GameEngine extends Game {
  Size screenSize;

  double tileSize;

  List<EnemyShooter> enemyShooters;

  GameEngine() {
    this.initialize();
  }

  void initialize() async {
    this.enemyShooters = List<EnemyShooter>();

    resize(await Flame.util.initialDimensions());

    this.spawnEnemyShooter();
  }

  void render(Canvas canvas) {
    Rect background = Rect.fromLTWH(0, 0, this.screenSize.width, this.screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff576574);
    canvas.drawRect(background, bgPaint);

    this.enemyShooters.forEach((EnemyShooter es) => es.render(canvas));
  }

  void update(double t) {
    this.enemyShooters.forEach((EnemyShooter es) => es.update(t));
  }

  void resize(Size size) {
    this.screenSize = size;
    this.tileSize = this.screenSize.width/9;
  }

  void spawnEnemyShooter() {
    this.enemyShooters.add(EnemyShooter(this, 50, 50));
  }
}