import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:head_into_space/Views/PlayingView.dart';

class HighscoreDisplay {
  final GameEngine game;

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
    int highscore = this.game.storage.getInt("highscore");

    this.painter.text = TextSpan(
      text: "Highscore: " + highscore.toString(),
      style: textStyle,
    );

    this.painter.layout();

    this.position = Offset(
        this.game.screenSize.width / 2 - this.painter.width / 2,
        this.game.screenSize.height / 2 - this.painter.height / 2);
  }
}
