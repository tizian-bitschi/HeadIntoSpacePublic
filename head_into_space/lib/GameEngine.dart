import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'dart:developer' as console;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:head_into_space/Bullets/FriendlyLaser.dart';
import 'package:head_into_space/Enemy.dart';
import 'package:head_into_space/Background.dart';
import 'package:head_into_space/Bullet.dart';
import 'package:head_into_space/Enemies/Shooter.dart';
import 'package:head_into_space/Player.dart';
import 'package:sensors/sensors.dart';
import 'package:esense_flutter/esense.dart';

class GameEngine extends Game {
  Size screenSize;

  bool withHead = false;

  double tileSize; // Size of a tile based on the screen width.
  double spawnSpeed = 250;
  double spawnCooldown = 0;

  math.Random rnd;

  List<Enemy> enemies;
  List<Bullet> bullets;

  AccelerometerEvent acceleration;

  StreamSubscription<AccelerometerEvent> _streamSubscription;
  StreamSubscription<SensorEvent> _sensorSubscription;

  Player player;

  Background background;

  GameEngine() {
    this.initialize();
  }

  // To avoid that basic initializations are redone in the resize function, there is one especially for that here.
  void initialize() async {
    ESenseManager.connectionEvents.listen((event) {
      console.log('CONNECTION event: $event');
    });

    bool success = await ESenseManager.connect("eSense-1409");
    console.log("Connected: " + success.toString());

    console.log(ESenseManager.connected.toString());
    console.log(ESenseManager.eSenseDeviceName);
    ESenseManager.sensorEvents.listen((event) {
      console.log(event.toString());
    });

    this.rnd = math.Random();

    //_streamSubscription =
    //    accelerometerEvents.listen((AccelerometerEvent event) {
    //  this.player.move(event);
    //});

    this.enemies = List<Enemy>();
    this.bullets = List<Bullet>();

    this.resize(await Flame.util.initialDimensions());

    this.background = Background(this);

    this.player = Player(
        this, this.tileSize * 4, this.screenSize.height - (tileSize * 3));
  }

  void render(Canvas canvas) {
    this.background.render(canvas);

    this.bullets.forEach((Bullet b) => b.render(canvas));

    this.enemies.forEach((Enemy es) => es.render(canvas));

    this.player.render(canvas);
  }

  void update(double t) {
    if (this.spawnCooldown > this.spawnSpeed) {
      this.spawnEnemy();
      this.spawnCooldown = 0;
    }

    this.enemies.forEach((Enemy es) {
      es.update(t);
      this.bullets.forEach((Bullet b) {
        if (es.enemyRect.contains(b.bulletRect.topCenter) && b.friendly) {
          es.onHit(b.damage);
          b.destroy();
        }

        if (this.player.playerRect.contains(b.bulletRect.bottomCenter) &&
            !b.friendly) {
          this.player.onDamage(b);
          b.destroy();
        }
      });
    });
    this.bullets.forEach((Bullet b) => b.update(t));
    this.player.update(t);
    this.enemies.removeWhere((Enemy es) => es.toDestroy);
    this.bullets.removeWhere((Bullet b) => b.toDestroy);
    this.spawnCooldown++;
  }

  void onTap(TapUpDetails d) {}

  void spawnEnemy() {
    double x = this.rnd.nextDouble() * (this.screenSize.width - this.tileSize);
    double y = 0;

    this.enemies.add(Shooter(this, x, y));
  }

  void resize(Size size) {
    this.screenSize = size;
    this.tileSize = this.screenSize.width / 9;
  }
}
