import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:head_into_space/Views/PlayingView.dart';

class HighscoreDisplay {
  final PlayingView game;

  TextPainter painter;

  TextStyle textStyle;

  Offset position;

  HighscoreDisplay(this.game) {
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

  void updateHighscore() {
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
