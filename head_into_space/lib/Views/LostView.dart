import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:head_into_space/Buttons/StartButton.dart';
import 'package:head_into_space/Displays/HighscoreDisplay.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:head_into_space/View.dart';
import 'package:head_into_space/Views/PlayingView.dart';
import 'package:head_into_space/Displays/ScoreLostDisplay.dart';

class LostView {
  final GameEngine game;

  HighscoreDisplay highscoreDisplay;

  Rect lostRect;

  ScoreLostDisplay scoreLost;

  Sprite lostSprite;

  StartButton startButton;

  LostView(this.game) {
    this.lostRect = Rect.fromLTWH(this.game.tileSize, this.game.tileSize,
        this.game.tileSize * 7, this.game.tileSize * 2);
    this.lostSprite = Sprite('lost.png');
    this.startButton = StartButton(this.game);
    this.highscoreDisplay = HighscoreDisplay(this.game);
    this.highscoreDisplay.updateHighscore();
    this.scoreLost = ScoreLostDisplay(this.game);
  }

  void render(Canvas c) {
    this.lostSprite.renderRect(c, this.lostRect);
    this.startButton.render(c);
    this.highscoreDisplay.render(c);
    this.scoreLost.render(c);
  }

  void update(double t) {}

  void onTapDown(TapDownDetails d) {
    if (this.startButton.buttonRect.contains(d.globalPosition)) {
      this.game.playingView = PlayingView(this.game);
      this.game.activeView = View.playing;
    }
  }
}
