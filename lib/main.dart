import 'package:flutter/material.dart';
import 'dart:async';

import 'login/login.dart';
import 'transitions/fade_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xapp',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.black,
        fontFamily: 'Open Sans'
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(context, FadeRouteBuilder(page: Login()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Xapp',
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.black
          ),
        ),
      ),
    );
  }
}
