import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:flutter/gestures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  Util flameUtil = new Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  GameEngine game = GameEngine();
  runApp(game.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);
}