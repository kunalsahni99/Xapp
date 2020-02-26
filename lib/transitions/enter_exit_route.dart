import 'package:flutter/material.dart';

class EnterExitRoute extends PageRouteBuilder{
  final Widget enterPage, exitPage;

  EnterExitRoute({this.enterPage, this.exitPage})
      : super(
        pageBuilder: (context, animation, secAnimation) => enterPage,
        transitionsBuilder: (context, animation, secAnimation, child) =>
            Stack(
              children: <Widget>[
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 0),
                    end: Offset(-1.0, 0),
                  ).animate(animation),
                  child: exitPage,
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0),
                    end: Offset.zero
                  ).animate(animation),
                  child: enterPage,
                )
              ],
            )
      );
}