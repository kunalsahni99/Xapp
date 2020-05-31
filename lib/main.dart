import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:xapp/home/mainpage.dart';

import 'login/login.dart';
import 'utils/prefs.dart';
import 'login/onboarding.dart';
import 'utils/fade_in.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Prefs>(create: (_) => Prefs()),
        ChangeNotifierProvider<Count>(create: (_) => Count()),
      ],
      child: MaterialApp(
        title: 'Xapp',
        theme: ThemeData(
          primaryColor: Color(0xff73aef5),
          accentColor: Color(0xff73aef5),
          fontFamily: 'McLaren',
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
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  final Duration animationDuration = Duration(milliseconds: 300);
  Rect rect;
  var sp;
  bool firsTime;

  getPreferences() async{
    sp = await Utils().getPrefs();
    setState(() => firsTime = sp.getBool('firstTime') ?? true);
  }
  
  Widget ripple(){
    if (rect == null){
      return Container();
    }
    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white
        ),
      ),
    );
  }

  void _onTimeOut(Widget page) async{
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() =>
      rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
      Future.delayed(animationDuration, () {
        Navigator.pushReplacement(context, FadeRouteBuilder(page: page)).then((_) => setState(() => rect = null));
      });
    });
  }
  
  @override
  void initState() {
    super.initState();
    getPreferences();
    Timer(
      Duration(seconds: 4),
      (){
//        if (firsTime){
//          _onTimeOut(OnBoarding());
//        }
//        else{
//          //todo: check if user is logged in or not
//          _onTimeOut(Login());
//        }
        _onTimeOut(MainPage());
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xff398ae5)
      ),
      child: Stack(
        children: <Widget>[
          Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                    colors: [
                      Color(0xff73aef5),
                      Color(0xff61a4f1),
                      Color(0xff478de0),
                      Color(0xff398ae5)
                    ],
                    stops: [
                      0.1,
                      0.3,
                      0.8,
                      1
                    ],
                    focalRadius: 1.5
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RectGetter(
                    key: rectGetterKey,
                    child: Image.asset('images/logo.png',
                      width: 500.0,
                      height: 500.0,
                      color: Colors.white,
                    ),
                  ),

                  FadeIn(
                    delay: 4.0,
                    child: Text('WhyyU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ripple()
        ],
      ),
    );
  }
}