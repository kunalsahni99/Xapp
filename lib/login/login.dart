import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xapp/transitions/enter_exit_route.dart';

import '../utils/fade_in.dart';
import '../home/preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controller;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff73aef5),
                  Color(0xff61a4f1),
                  Color(0xff478de0),
                  Color(0xff398ae5)
                ],
                stops: [0.1, 0.4, 0.7, 0.9]
              ),
            ),
          ),

          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeIn(
                    delay: 1.0,
                    child: Center(
                      child: Text('Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0),

                  Center(
                    child: Column(
                      children: <Widget>[
                        FadeIn(
                          delay: 1.33,
                          child: Text('with',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0
                            ),
                          ),
                        ),

                        SizedBox(height: 30.0),

                        FadeIn(
                          delay: 1.66,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Phone number',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 10.0),

                                Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF6CA8F1),
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6.0,
                                        offset: Offset(0, 2)
                                      )
                                    ]
                                  ),
                                  height: 60.0,
                                  child: TextField(
                                    controller: controller,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(Icons.phone, color: Colors.white),
                                      hintText: 'Phone no',
                                      hintStyle: TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        FadeIn(
                          delay: 1.99,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
                            width: double.infinity,
                            child: RaisedButton(
                              elevation: 5.0,
                              // TODO: Add phone authentication functionality
                              onPressed: (){
                                //TODO: Don't remove this line
                                Future.delayed(Duration(seconds: 1));
                                if (controller.text.length != 10){
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  scaffoldKey.currentState?.removeCurrentSnackBar();
                                  scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text('Enter a valid number',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                        duration: Duration(seconds: 3),
                                      ));
                                }
                                else{

                                }
                              },
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.white,
                              child: Text('Generate OTP',
                                style: TextStyle(
                                  color: Color(0xFF527DAA),
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),

                        FadeIn(
                          delay: 2.2,
                          child: Column(
                            children: <Widget>[
                              Text('- OR -',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400
                                ),
                              ),

                              SizedBox(height: 20.0),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    // TODO: Facebook authentication
                                    onTap: (){},
                                    child: Container(
                                      height: 60.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(0, 2),
                                                blurRadius: 6.0
                                            )
                                          ],
                                          image: DecorationImage(
                                              image: AssetImage('images/fb.png',
                                              )
                                          )
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 30.0),

                                  GestureDetector(
                                    // TODO: Google authentication
                                    onTap: (){},
                                    child: Container(
                                      height: 60.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(0, 2),
                                                blurRadius: 6.0
                                            )
                                          ],
                                      ),
                                      child: Image.asset('images/google.png',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          Positioned(
            top: 30.0,
            right: 10.0,
            child: InkWell(
              onTap: () => Navigator.pushReplacement(context, EnterExitRoute(exitPage: Login(), enterPage: Preferences())),
              child: Container(
                width: 70.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: Color(0xff398ae5).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text('Skip',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),

                    Icon(Icons.arrow_forward_ios,
                      size: 10.0,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}