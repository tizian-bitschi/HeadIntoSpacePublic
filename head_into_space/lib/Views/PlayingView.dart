import 'dart:ui';
import 'dart:math' as math;
import 'package:head_into_space/Bullet.dart';
import 'package:head_into_space/Displays/HealthDisplay.dart';
import 'package:head_into_space/Displays/ScoreDisplay.dart';
import 'package:head_into_space/Enemies/Shooter.dart';
import 'package:head_into_space/Enemy.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:head_into_space/Player.dart';
import 'package:head_into_space/View.dart';

class PlayingView {
  final GameEngine game;

  List<Bullet> bullets;

  double spawnSpeed;
  double spawnCooldown;
  double tileSize;

  List<Enemy> enemies;

  HealthDisplay healthDisplay;

  int score;

  Player player;

  math.Random rnd;

  ScoreDisplay scoreDisplay;

  Size screenSize;

  PlayingView(this.game) {
    this.tileSize = this.game.tileSize;
    this.screenSize = this.game.screenSize;
    this.initialize();
  }

  void initialize() {
    this.rnd = math.Random();

    this.spawnSpeed = 175;
    this.spawnCooldown = 0;
    this.score = 0;

    this.enemies = List<Enemy>();
    this.bullets = List<Bullet>();

    this.scoreDisplay = ScoreDisplay(this);

    this.healthDisplay = HealthDisplay(this);

    this.player = Player(this, this.game.tileSize * 4,
        this.game.screenSize.height - (this.game.tileSize * 3));
  }

  void render(Canvas c) {
    this.bullets.forEach((Bullet b) => b.render(c));

    this.enemies.forEach((Enemy es) => es.render(c));

    this.player.render(c);

    this.scoreDisplay.render(c);
    this.healthDisplay.render(c);
  }

  void update(double t) {
    if (this.player.health > 0) {
      if (this.spawnCooldown > this.spawnSpeed) {
        this.spawnEnemy();
        this.spawnCooldown = 0;
      }

      this.enemies.forEach((Enemy es) {
        this.bullets.forEach((Bullet b) {
          if (es.enemyRect.contains(b.bulletRect.topCenter) && b.friendly) {
            es.onHit(b.damage);
            b.destroy();
          }
        });
        es.update(t);
      });
      this.bullets.forEach((Bullet b) {
        if (this.player.playerRect.contains(b.bulletRect.bottomCenter) &&
            !b.friendly) {
          this.player.onDamage(b);
          b.destroy();
        }
        b.update(t);
      });
      this.enemies.removeWhere((Enemy es) => es.toDestroy);
      this.bullets.removeWhere((Bullet b) => b.toDestroy);
      this.player.update(t);
      this.scoreDisplay.update(t);
      this.healthDisplay.update(t);
      this.spawnCooldown++;
    } else {
      this.game.activeView = View.lost;
    }
  }

  void spawnEnemy() {
    double x = this.rnd.nextDouble() * 8;
    double y = 0;

    this.enemies.add(Shooter(this, x * this.game.tileSize, y));
  }
}
