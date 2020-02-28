import 'dart:developer' as console;
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:flutter/gestures.dart';
import 'package:sensors/sensors.dart' as sensors;
import 'package:esense_flutter/esense.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Util flameUtil = new Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  Flame.images.loadAll(<String>[
    'NebulaBlue.png',
    'Enemies/enemyRed1.png',
    'explosion-0.png',
    'explosion-1.png',
    'explosion-2.png',
    'explosion-3.png',
    'explosion-4.png',
    'explosion-5.png',
    'explosion-6.png',
    'Lasers/laserBlue03.png'
  ]);

  SharedPreferences storage = await SharedPreferences.getInstance();

  GameEngine game = GameEngine(storage);
  runApp(game.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);
}
