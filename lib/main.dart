import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:xapp/utils/prefs.dart';
import 'home/mainpage.dart';
import 'transitions/fade_route.dart';

void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xff73aef5),
    statusBarColor: Color(0xff73aef5),
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Prefs>(
      create: (_) => Prefs(),
      child: MaterialApp(
        title: 'Xapp',
        theme: ThemeData(
          primaryColor: Color(0xff73aef5),
          accentColor: Color(0xff73aef5),
          fontFamily: 'Open Sans',
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
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
      () => Navigator.pushReplacement(context, FadeRouteBuilder(page: MainPage()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white
      ),
      child: Scaffold(
        body: Center(
          child: Text('Xapp',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.black
            ),
          ),
        ),
      ),
    );
  }
}
