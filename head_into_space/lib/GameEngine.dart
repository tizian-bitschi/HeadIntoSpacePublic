import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'dart:developer' as console;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:head_into_space/Enemy.dart';
import 'package:head_into_space/Background.dart';
import 'package:head_into_space/Bullet.dart';
import 'package:head_into_space/Enemies/Shooter.dart';
import 'package:head_into_space/Player.dart';
import 'package:esense_flutter/esense.dart';
import 'package:sensors/sensors.dart';

class GameEngine extends Game {
  // ESENSE //
  String _deviceName = 'Unknown';
  double _voltage = -1;
  String _deviceStatus = '';
  bool sampling = false;
  String _event = '';
  String _button = 'not pressed';

  StreamSubscription subscription;

  // the name of the eSense device to connect to -- change this to your own device.
  String eSenseName = 'eSense-0678';
  ////////////

  Size screenSize;

  bool withHead = false;
  bool tryConnect = true;
  bool listening = false;

  double tileSize; // Size of a tile based on the screen width.
  double spawnSpeed = 250;
  double spawnCooldown = 0;
  double cooldown = 30;

  math.Random rnd;

  math.Point<double> accel = math.Point<double>(0, 0);

  String deviceAccel = "";

  List<Enemy> enemies;
  List<Bullet> bullets;

  Player player;

  Background background;

  GameEngine() {
    this.initialize();
  }

  // To avoid that basic initializations are redone in the resize function, there is one especially for that here.
  void initialize() async {
    this._connectToESense();

    this.rnd = math.Random();

    accelerometerEvents.listen((AccelerometerEvent event) {
      this.deviceAccel = "Device accel - X: " +
          event.x.toString() +
          ", Y: " +
          event.y.toString() +
          ", Z: " +
          event.z.toString();
    });

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
    if (cooldown < 0) {
      console.log(this._event);
      console.log("Direction - " + this.accel.toString());

      cooldown = 120;
      if (this._deviceStatus == "connected" && !this.listening) {
        this._startListenToSensorEvents();
      }
    }
    cooldown--;

    if (listening) {
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

  // --- ESENSE FUNCTIONS --- //
  Future<void> _connectToESense() async {
    bool con = false;

    // if you want to get the connection events when connecting, set up the listener BEFORE connecting...
    ESenseManager.connectionEvents.listen((event) {
      console.log('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) _listenToESenseEvents();

      switch (event.type) {
        case ConnectionType.connected:
          _deviceStatus = 'connected';
          break;
        case ConnectionType.unknown:
          console.log(ESenseManager.eSenseDeviceName);
          _deviceStatus = 'unknown';
          break;
        case ConnectionType.disconnected:
          _deviceStatus = 'disconnected';
          break;
        case ConnectionType.device_found:
          _deviceStatus = 'device_found';
          break;
        case ConnectionType.device_not_found:
          console.log(ESenseManager.eSenseDeviceName);
          _deviceStatus = 'device_not_found';
          break;
      }
    });

    con = await ESenseManager.connect(eSenseName);

    _deviceStatus = con ? 'connecting' : 'connection failed';
    console.log(_deviceStatus);
  }

  void _listenToESenseEvents() async {
    ESenseManager.eSenseEvents.listen((event) {
      console.log('ESENSE event: $event');

      switch (event.runtimeType) {
        case DeviceNameRead:
          _deviceName = (event as DeviceNameRead).deviceName;
          break;
        case BatteryRead:
          _voltage = (event as BatteryRead).voltage;
          break;
        case ButtonEventChanged:
          _button =
              (event as ButtonEventChanged).pressed ? 'pressed' : 'not pressed';
          break;
        case AccelerometerOffsetRead:
          // TODO
          break;
        case AdvertisementAndConnectionIntervalRead:
          // TODO
          break;
        case SensorConfigRead:
          // TODO
          break;
      }
    });

    _getESenseProperties();
  }

  void _getESenseProperties() async {
    // get the battery level every 10 secs
    Timer.periodic(Duration(seconds: 10),
        (timer) async => await ESenseManager.getBatteryVoltage());

    // wait 2, 3, 4, 5, ... secs before getting the name, offset, etc.
    // it seems like the eSense BTLE interface does NOT like to get called
    // several times in a row -- hence, delays are added in the following calls
    Timer(
        Duration(seconds: 2), () async => await ESenseManager.getDeviceName());
    Timer(Duration(seconds: 3),
        () async => await ESenseManager.getAccelerometerOffset());
    Timer(
        Duration(seconds: 4),
        () async =>
            await ESenseManager.getAdvertisementAndConnectionInterval());
    Timer(Duration(seconds: 5),
        () async => await ESenseManager.getSensorConfig());
  }

  void _startListenToSensorEvents() async {
    // subscribe to sensor event from the eSense device
    subscription = ESenseManager.sensorEvents.listen((event) {
      this.listening = true;
      //console.log('SENSOR event: $event');
      _event = event.toString();
      double tempX = 0;
      double tempY = 0;
      if (event.accel[1] > -1200 && event.accel[2] < 800) {
        tempY = -1;
      } else if (event.accel[1] < -4300 && event.accel[2] > 1200) {
        tempY = 1;
      } else if (event.accel[1] < -3400 && event.accel[2] > -600) {
        tempX = -1;
      } else if (event.accel[1] > -2600 && event.accel[2] > 2000) {
        tempX = 1;
      }
      this.accel = math.Point<double>(tempX, tempY);
    });

    sampling = true;
  }

  void _pauseListenToSensorEvents() async {
    subscription.cancel();

    sampling = false;
  }
}
