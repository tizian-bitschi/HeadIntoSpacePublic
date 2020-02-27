import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:head_into_space/GameEngine.dart';

class ScoreDisplay {
  final GameEngine game;

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
      fontSize: 25,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 3,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
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
