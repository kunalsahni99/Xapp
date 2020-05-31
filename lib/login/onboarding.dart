import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nice_intro/intro_screen.dart';
import 'package:nice_intro/intro_screens.dart';
import 'package:flutter/services.dart';

import 'package:xapp/login/login.dart';
import 'package:xapp/transitions/enter_exit_route.dart';

class OnBoarding extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    List<IntroScreen> pages = [
      IntroScreen(
        title: 'Search',
        description: 'Quickly find your messages',
        imageAsset: 'images/onboard1.png',
      ),
      IntroScreen(
        title: 'Share',
        description: 'Spread your thoughts worldwide',
        imageAsset: 'images/onboard2.png',
      ),
      IntroScreen(
        title: 'Socialize',
        description: 'Keep in touch with your mates',
        imageAsset: 'images/onboard3.png',
      )
    ];
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.white),
      child: Scaffold(
        body: IntroScreens(
          slides: pages,
          footerBgColor: Color(0xff73aef5),
          footerRadius: 20.0,
          indicatorType: IndicatorType.LINE,
          onDone: () => Navigator.pushReplacement(context, EnterExitRoute(enterPage: Login(), exitPage: OnBoarding())),
          onSkip: () => Navigator.pushReplacement(context, EnterExitRoute(enterPage: Login(), exitPage: OnBoarding())),
        )
      ),
    );
  }
}