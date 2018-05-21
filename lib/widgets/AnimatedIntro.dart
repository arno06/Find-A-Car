import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedIntro extends AnimatedWidget{
  AnimatedIntro({Key key, Animation<double> animation})
    :super(key:key, listenable:animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double margin = animation.value * 80.0;
    double alpha = 1.0 - animation.value;
    return new Center(
        child:new Opacity(opacity: alpha,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding:new EdgeInsets.only(bottom: 20.0 + margin),
                child: new CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              ),
              new Container(
                padding:new EdgeInsets.only(top:margin),
                child: new Text("Chargement..."),
              ),
            ],
          ),
        )
    );
  }


}