import 'dart:ui';
import 'dart:developer' as console;
import 'package:head_into_space/Bullet.dart';
import 'package:head_into_space/Bullets/LaserLevelOne.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:flame/sprite.dart';
import 'package:head_into_space/Views/PlayingView.dart';

class Enemy {
  final PlayingView game;

  Bullet bullet;

  bool isDead = false;
  bool toDestroy = false;

  Rect enemyRect;

  List<Sprite> deadAnimation;

  Sprite aliveSprite;

  double deadSpriteIndex;
  double health;
  double speed;
  double shootSpeed;
  double shootCooldown = 0;

  Enemy(this.game, double x, double y) {
    this.bullet = LaserLevelOne(this.game, 0, 0);
    this.enemyRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    this.deadAnimation = List<Sprite>();
    this.deadAnimation.add(Sprite('explosion-0.png'));
    this.deadAnimation.add(Sprite('explosion-1.png'));
    this.deadAnimation.add(Sprite('explosion-2.png'));
    this.deadAnimation.add(Sprite('explosion-3.png'));
    this.deadAnimation.add(Sprite('explosion-4.png'));
    this.deadAnimation.add(Sprite('explosion-5.png'));
    this.deadAnimation.add(Sprite('explosion-6.png'));
    this.deadSpriteIndex = 0;
  }

  void render(Canvas c) {
    if (this.isDead) {
      this
          .deadAnimation[this.deadSpriteIndex.toInt()]
          .renderRect(c, this.enemyRect);
    } else {
      this.aliveSprite.renderRect(c, this.enemyRect);
    }
  }

  void update(double t) {
    if (this.enemyRect.bottom > this.game.screenSize.height) {
      this.isDead = true;
    }

    if (this.isDead && this.deadSpriteIndex < 7) {
      this.deadSpriteIndex += 1;
    }

    if (this.deadSpriteIndex > 6) {
      this.toDestroy = true;
      if (this.game.spawnSpeed > 5) {
        this.game.spawnSpeed -= 1;
      }
    }

    if (this.shootCooldown > this.shootSpeed) {
      this.game.bullets.add(
          LaserLevelOne(this.game, this.enemyRect.left, this.enemyRect.top));
      this.shootCooldown = 0;
    }

    if (!this.isDead) {
      this.enemyRect =
          this.enemyRect.translate(0, this.game.tileSize * this.speed * t);
      this.shootCooldown++;
    }
  }

  void onHit(double damage) {
    if (this.health - damage < 0) {
      this.health = 0;
      this.isDead = true;
      this.game.score++;
    } else {
      this.health -= damage;
    }
  }
}
