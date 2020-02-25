import 'dart:ui';

import 'package:flame/components/component.dart';

class Component extends SpriteComponent {
  //Receives delta time in milliseconds since last update and allows to move to the next state.
  @override
  void update(double t) {}

  //Used to inform the BaseGame that the object is marked for destruction.
  @override
  bool destroy() {
    bool remove;
    return remove;
  }

  //Called whenever the screen is resized and in the beginning once when the component is added via the add method.
  @override
  void resize(Size size) {
    
  }
}