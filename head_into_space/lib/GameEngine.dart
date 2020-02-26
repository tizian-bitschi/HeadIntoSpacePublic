import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:head_into_space/EnemyShooter.dart';
import 'package:head_into_space/Background.dart';

class GameEngine extends Game {
  Size screenSize;

  double tileSize; // Size of a tile based on the screen width.

  Random rnd;

  List<EnemyShooter> enemyShooters;

  Background background;

  GameEngine() {
    this.initialize();
  }

  // To avoid that basic initializations are redone in the resize function, there is one especially for that here.
  void initialize() async {
    this.rnd = Random();

    this.enemyShooters = List<EnemyShooter>();

    this.resize(await Flame.util.initialDimensions());

    this.background = Background(this);

    this.spawnEnemyShooter();
  }

  void render(Canvas canvas) {
    this.background.render(canvas);

    this.enemyShooters.forEach((EnemyShooter es) => es.render(canvas));
  }

  void update(double t) {
    this.enemyShooters.forEach((EnemyShooter es) => es.update(t));
    this.enemyShooters.removeWhere((EnemyShooter es) => es.isOffScreen);
  }

  void onTapDown(TapDownDetails d) {
    this.enemyShooters.forEach((EnemyShooter es) {
      if (es.enemyShooterRect.contains(d.globalPosition)) {
        es.onTapDown();
      }
    });
  }

  void spawnEnemyShooter() {
    double x = this.rnd.nextDouble() * (this.screenSize.width - this.tileSize);
    double y = this.rnd.nextDouble() * (this.screenSize.height - this.tileSize);

    this.enemyShooters.add(EnemyShooter(this, x, y));
  }

  void resize(Size size) {
    this.screenSize = size;
    this.tileSize = this.screenSize.width/9;
  }
}