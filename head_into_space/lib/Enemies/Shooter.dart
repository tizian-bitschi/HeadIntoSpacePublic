import 'package:flame/sprite.dart';
import 'package:head_into_space/Enemy.dart';
import 'package:head_into_space/Views/PlayingView.dart';

class Shooter extends Enemy {
  Shooter(PlayingView game, double x, double y) : super(game, x, y) {
    this.aliveSprite = Sprite('Enemies/enemyRed1.png');
    this.health = 10;
    this.speed = 2;
    this.shootSpeed = 75;
  }
}
