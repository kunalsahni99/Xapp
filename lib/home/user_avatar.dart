import 'package:flutter/material.dart';

import '../utils/prefs.dart';
import '../utils/valley_quad_curve.dart';

class UserAvatar extends StatelessWidget {
  final String name, pUrl;
  final int tag;

  UserAvatar({this.pUrl, this.name, this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Hero(
          flightShuttleBuilder: (BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext){
            final Hero toHero = toHeroContext.widget;

            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(begin: 0.0, end: 1.0).chain(
                    CurveTween(
                        curve: Interval(0.0, 1.0,
                            curve: ValleyQuadraticCurve()
                        )
                    )
                ),
              ),
              child: toHero.child,
            );
          },
        tag: tag,
        child: Center(child: Image.asset(pUrl))
      ),
    );
  }
}