import 'package:flame/sprite.dart';
import 'package:head_into_space/Bullet.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:head_into_space/Views/PlayingView.dart';

class LaserLevelOne extends Bullet {
  LaserLevelOne(PlayingView game, double x, double y) : super(game,x,y) {
    this.friendly = false;
    this.bulletSpeed = 7;
    this.bulletDirection = 1;
    this.bulletSprite = Sprite('Lasers/laserRed03.png');
    this.damage = 10;
  }
}