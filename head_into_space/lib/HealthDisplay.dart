import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:head_into_space/GameEngine.dart';

class HealthDisplay {
  final GameEngine game;

  TextPainter painter;

  TextStyle textStyle;

  Offset position;

  HealthDisplay(this.game) {
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
    if ((painter.text?.text ?? '') !=
        "Health: " + this.game.player.health.toString()) {
      this.painter.text = TextSpan(
        text: "Health: " + this.game.player.health.toString(),
        style: textStyle,
      );

      this.painter.layout();

      this.position = Offset(0, this.painter.height / 2);
    }
  }
}
