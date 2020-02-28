import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:head_into_space/Buttons/StartButton.dart';
import 'package:head_into_space/GameEngine.dart';
import 'package:head_into_space/View.dart';

class HomeView {
  final GameEngine game;

  Rect titleRect;

  Sprite titleSprite;

  StartButton startButton;

  HomeView(this.game) {
    this.titleRect = Rect.fromLTWH(this.game.tileSize, this.game.tileSize,
        this.game.tileSize * 7, this.game.tileSize * 2);
    this.titleSprite = Sprite('banner.png');
    this.startButton = StartButton(this.game);
  }

  void render(Canvas c) {
    this.titleSprite.renderRect(c, this.titleRect);
    this.startButton.render(c);
  }

  void update(double t) {}

  void onTapDown(TapDownDetails d) {
    if (this.startButton.buttonRect.contains(d.globalPosition)) {
      this.game.activeView = View.playing;
    }
  }
}
