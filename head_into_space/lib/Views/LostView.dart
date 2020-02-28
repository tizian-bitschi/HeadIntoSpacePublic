import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:head_into_space/Buttons/StartButton.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:head_into_space/View.dart';
import 'package:head_into_space/Views/PlayingView.dart';

class LostView {
  final GameEngine game;

  Rect lostRect;

  Sprite lostSprite;

  StartButton startButton;

  LostView(this.game) {
    this.lostRect = Rect.fromLTWH(this.game.tileSize, this.game.tileSize,
        this.game.tileSize * 7, this.game.tileSize * 2);
    this.lostSprite = Sprite('lost.png');
    this.startButton = StartButton(this.game);
  }

  void render(Canvas c) {
    this.lostSprite.renderRect(c, this.lostRect);
    this.startButton.render(c);
  }

  void update(double t) {}

  void onTapDown(TapDownDetails d) {
    if (this.startButton.buttonRect.contains(d.globalPosition)) {
      this.game.playingView = PlayingView(this.game);
      this.game.activeView = View.playing;
    }
  }
}
