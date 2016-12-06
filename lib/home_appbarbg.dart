import 'package:flutter/material.dart';
import 'bemilo.dart';


class _BackgroundLayer {
  _BackgroundLayer({ int level, double parallax })
    : assetName = 'assets/appbar/appbar_background_layer$level.png',
      parallaxTween = new Tween<double>(begin: 0.0, end: parallax);
  final String assetName;
  final Tween<double> parallaxTween;
}

final List<_BackgroundLayer> _kBackgroundLayers = <_BackgroundLayer>[
  new _BackgroundLayer(level: 0, parallax: kFlexibleSpaceMaxHeight),
  new _BackgroundLayer(level: 1, parallax: kFlexibleSpaceMaxHeight),
  new _BackgroundLayer(level: 2, parallax: kFlexibleSpaceMaxHeight / 2.0),
  new _BackgroundLayer(level: 3, parallax: kFlexibleSpaceMaxHeight / 4.0),
  new _BackgroundLayer(level: 4, parallax: kFlexibleSpaceMaxHeight / 2.0),
  new _BackgroundLayer(level: 5, parallax: kFlexibleSpaceMaxHeight)
];


class HomeAppBarBackground extends StatelessWidget {
  HomeAppBarBackground({ Key key, this.animation }) : super(key: key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    // TODO(abarth): Wire up to the parallax of the FlexibleSpaceBar in a way
    // that doesn't pop during hero transition.
    Animation<double> effectiveAnimation = kAlwaysDismissedAnimation;
    return new AnimatedBuilder(
      animation: effectiveAnimation,
      builder: (BuildContext context, Widget child) {
        return new Stack(
          children: _kBackgroundLayers.map((_BackgroundLayer layer) {
            return new Positioned(
              top: -layer.parallaxTween.evaluate(effectiveAnimation),
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: new Image.asset(
                layer.assetName,
                fit: ImageFit.cover,
                height: kFlexibleSpaceMaxHeight
              )
            );
          }).toList()
        );
      }
    );
  }
}
