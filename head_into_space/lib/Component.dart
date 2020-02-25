import 'dart:ui';
import 'package:flame/components/component.dart';

const SPEED = 120.0;
const ComponentSize = 40.0;

class Component extends SpriteComponent {
  Future<Size> dimensions;

  Component(this.dimensions) : super.square(ComponentSize, "dragon.png");

  double maxY;
  bool remove = false;

  //Receives delta time in milliseconds since last update and allows to move to the next state.
  @override
  void update(double t) {
    y += t * SPEED;
  }

  //Used to inform the BaseGame that the object is marked for destruction.
  @override
  bool destroy() {
    return remove;
  }

  //Called whenever the screen is resized and in the beginning once when the component is added via the add method.
  @override
  void resize(Size size) {
    this.x = size.width / 2;
    this.y = 0;
    this.maxY = size.height;
  }
}
