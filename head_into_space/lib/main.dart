import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

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

class MyApp extends BaseGame {
  Future<Size> dimensions;

  MyApp(this.dimensions);

  //Makes canvas ready to draw something on it (a sprite).
  @override
  void render(Canvas canvas) {
    String text = "Score: 0";
    TextPainter textPainter =
        Flame.util.text(text, color: Colors.white, fontSize: 48.0);
    textPainter.paint(canvas, Offset(size.width / 5, size.height / 2));
  }

  //Receives time input that helps in moving on to the next state.
  @override
  void update(double t) {}
}
