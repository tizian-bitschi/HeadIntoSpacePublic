import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:head_into_space/Views/PlayingView.dart';

class ScoreLostDisplay {
  final GameEngine game;

  TextPainter painter;

  TextStyle textStyle;

  Offset position;

  ScoreLostDisplay(this.game) {
    this.painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    this.textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 30,
      fontFamily: "Nulshock",
    );

    position = Offset.zero;
  }

  void render(Canvas c) {
    this.painter.paint(c, this.position);
  }

  void updateScore() {
    int score = this.game.playingView.score;

    this.painter.text = TextSpan(
      text: "Your score: " + score.toString(),
      style: textStyle,
    );

    this.painter.layout();

    this.position = Offset(
        this.game.screenSize.width / 2 - this.painter.width / 2,
        this.game.screenSize.height / 2 - this.game.tileSize * 2);
  }
}
