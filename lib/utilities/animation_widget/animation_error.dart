import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class AnimatedWidg extends AnimatedWidget {

  Widget widgetError;

  // Make the Tweens static because they don't change.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 300, end: 300);

  AnimatedWidg({Key key, Animation<double> animation,this.widgetError})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: _sizeTween.evaluate(animation),
          width: _sizeTween.evaluate(animation),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}


