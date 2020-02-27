import 'dart:ui';

import 'package:head_into_space/GameEngine.dart';

class Button {
  final GameEngine game;

  String label;

  double x;
  double y;
  double width;
  double height;

  double maxX;
  double minX;
  double maxY;
  double minY;

  Paint paint;

  Rect buttonRect;

  Button(this.game, this.x, this.y, this.width, this.height,
      Color color) {
    this.buttonRect = Rect.fromLTWH(this.x, this.y, this.width, this.height);
    this.paint = Paint();
    this.paint.color = color;
  }

  void render(Canvas c) {
    c.drawRect(this.buttonRect, this.paint);
  }

  void update(double t) {}

  void onMove(double x, double y) {

    
  }
}
