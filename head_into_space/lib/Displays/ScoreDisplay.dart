import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:head_into_space/Views/PlayingView.dart';

class ScoreDisplay {
  final PlayingView game;

  TextPainter painter;

  TextStyle textStyle;

  Offset position;

  ScoreDisplay(this.game) {
    this.painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    this.textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 20,
      fontFamily: "Nulshock",
    );

    position = Offset.zero;
  }

  void render(Canvas c) {
    this.painter.paint(c, this.position);
  }

  void update(double t) {
    if ((this.painter.text?.text ?? '') !=
        "Score: " + this.game.score.toString()) {
      this.painter.text = TextSpan(
        text: "Score: " + this.game.score.toString(),
        style: textStyle,
      );

      this.painter.layout();

      this.position = Offset(this.game.screenSize.width - this.painter.width,
          this.painter.height / 2);
    }
  }
}
