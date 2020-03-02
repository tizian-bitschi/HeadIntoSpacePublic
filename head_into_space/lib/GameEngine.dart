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
import 'package:head_into_space/Views/LostView.dart';
import 'package:wakelock/wakelock.dart';
import 'package:head_into_space/Displays/ScoreDisplay.dart';
import 'package:head_into_space/Displays/HealthDisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:head_into_space/View.dart';
import 'package:head_into_space/Views/HomeView.dart';
import 'package:head_into_space/Views/PlayingView.dart';

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

  final SharedPreferences storage;

  View activeView = View.home;

  HomeView homeView;

  PlayingView playingView;

  LostView lostView;

  Size screenSize;

  bool withHead = false;
  bool tryConnect = true;
  bool listening = false;

  double cooldown;
  double tileSize; // Size of a tile based on the screen width.

  String deviceAccel = "";

  Background background;

  GameEngine(this.storage) {
    this.initialize();
  }

  // To avoid that basic initializations are redone in the resize function, there is one especially for that here.
  void initialize() async {
    Wakelock.enable();

    this.resize(await Flame.util.initialDimensions());

    if (this.storage.getInt("highscore") == null) {
      this.storage.setInt("highscore", 0);
    }

    this._connectToESense();

    this.cooldown = 120;

    this.homeView = HomeView(this);
    this.playingView = PlayingView(this);
    this.lostView = LostView(this);

    this.background = Background(this);
  }

  void render(Canvas canvas) {
    if (this.listening) {
      this.background.render(canvas);

      if (this.activeView == View.home) this.homeView.render(canvas);
      if (this.activeView == View.playing) this.playingView.render(canvas);
      if (this.activeView == View.lost) this.lostView.render(canvas);
    }
  }

  void update(double t) {
    if (this.cooldown <= 0 &&
        this._deviceStatus == "connected" &&
        !this.listening) {
      this.cooldown = 120;
      this._startListenToSensorEvents();
    }
    this.cooldown--;

    if (this.activeView == View.home) this.homeView.update(t);
    if (this.activeView == View.playing) this.playingView.update(t);
    if (this.activeView == View.lost) this.lostView.update(t);
  }

  void onTapDown(TapDownDetails d) {
    if (this.listening) {
      if (this.activeView == View.home) this.homeView.onTapDown(d);
      if (this.activeView == View.lost) this.lostView.onTapDown(d);
    }
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
    console.log(this._event);
    // subscribe to sensor event from the eSense device
    subscription = ESenseManager.sensorEvents.listen((event) {
      this.listening = true;
      //console.log('SENSOR event: $event');
      _event = event.toString();
      if (this.activeView == View.playing) {
        double tempX = 0;
        double tempY = 0;
        if (event.accel[1] > 500) {
          tempY = -1 * (event.accel[1] / 6600);
        } else if (event.accel[1] <= 500 && event.accel[1] >= -500) {
          tempY = 0;
        } else {
          tempY = event.accel[1] / -8000;
        }
        if (event.accel[2] > 500) {
          tempX = event.accel[2] / 7200;
        } else if (event.accel[2] <= 500 && event.accel[2] >= -500) {
          tempX = 0;
        } else {
          tempX = -1 * (event.accel[2] / -9600);
        }
        this.playingView.player.move(math.Point<double>(tempX, tempY));
      }
    });

    sampling = true;
  }

  void _pauseListenToSensorEvents() async {
    subscription.cancel();

    this.listening = false;

    sampling = false;
  }
}
