import 'dart:ui';
import 'dart:developer' as console;
import 'package:head_into_space/GameEngine.dart';
import 'package:flame/sprite.dart';

class Enemy {
  final GameEngine game;

  bool isDead = false;
  bool toDestroy = false;

  Rect enemyRect;

  List<Sprite> deadAnimation;

  Sprite aliveSprite;

  double deadSpriteIndex;
  double health;

  Enemy(this.game, double x, double y) {
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
    if (this.isDead && this.deadSpriteIndex < 7) {
      this.deadSpriteIndex += 1;
    }

    if (this.deadSpriteIndex > 6) {
      this.toDestroy = true;
    }
  }

  void onTapDown() {
    this.isDead = true;
  }

  void onHit(double damage) {
    console.log("Health: " + this.health.toString());
    if (this.health - damage < 0) {
      this.health = 0;
      this.isDead = true;
    } else {
      this.health -= damage;
    }
  }
}
