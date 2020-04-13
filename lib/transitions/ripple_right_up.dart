import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

class RippleRightUp extends PageRouteBuilder {
  final Widget page;
  final bool isRightUp;

  RippleRightUp({this.page, this.isRightUp})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        effectMap[isRightUp ? PageTransitionType.rippleRightUp : PageTransitionType.rippleRightDown](Curves.linear, animation, secondaryAnimation, child),
  );
}