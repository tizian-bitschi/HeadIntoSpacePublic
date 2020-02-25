import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:head_into_space/Component.dart';

var game;

main() async {
  var dimensions = Flame.util.initialDimensions();
  game = MyApp(dimensions);

  runApp(MaterialApp(
      home: Scaffold(
    body: Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: GameWrapper(game),
    ),
  )));
}

class GameWrapper extends StatelessWidget {
  final MyApp game;

  GameWrapper(this.game);

  @override
  Widget build(BuildContext context) {
    return game.widget;
  }
}

Component component;

class MyApp extends BaseGame {
  Future<Size> dimensions;

  MyApp(this.dimensions);

  //Makes canvas ready to draw something on it (a sprite).
  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  double creationTimer = 0.0;

  //Receives time input that helps in moving on to the next state.
  @override
  void update(double t) {
    creationTimer += t;
    if (creationTimer >= 4) {
      creationTimer = 0.0;
      component = new Component(dimensions);
      add(component);
    }
    super.update(t);
  }
}
