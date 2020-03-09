import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fade/fade.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../transitions/slide_top_route.dart';
import 'add_post.dart';
import '../utils/app_bar.dart';

bool disAg = false, Ag = false;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controller;
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  Future<bool> _onWillPopScope() {
    if (controller.offset > 0.0) {
      controller.animateTo(0,
          duration: Duration(seconds: 1), curve: Curves.easeIn);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Press again to exit');
        return Future.value(false);
      }
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xff73aef5)
      ),
      child: WillPopScope(
        onWillPop: _onWillPopScope,
        child: Scaffold(
          appBar: TopBar(title: 'Whyyu'),
          body: PageView.builder(
            itemCount: 10,
            controller: controller,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => GestureDetector(
              onPanUpdate: (details){
                if (details.delta.dx > 0){
                  //todo: right swipe
                  setState(() => Ag = true);
                  Timer(
                    Duration(milliseconds: 500),
                    () => setState(() => Ag = false)
                  );
                }
                else if (details.delta.dx < 0){
                  //todo: left swipe
                  setState(() => disAg = true);
                  Timer(
                      Duration(milliseconds: 500),
                      () => setState(() => disAg = false)
                  );
                }
              },
              child: SinglePost()
            ),
          ),

          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: FloatingActionButton(
              onPressed: () => Navigator.push(context, SlideTopRoute(page: AddPost())),
              backgroundColor: Color(0xff73aef5),
              child: Icon(FontAwesomeIcons.plus, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class SinglePost extends StatefulWidget {
  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/pic.jpg'),
                  ),
                ),

                Text('Kunal Sahni',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0
                  ),
                )
              ],
            ),

            Image.asset('images/something.jpg',
              width: MediaQuery.of(context).size.width,
            ),

            //TODO: heading
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text("Some shitty thought you can\'t imagine",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                ),
              ),
            ),

            //todo: description
            Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: Text("No one gives a fuck to this post so scroll down, you'll find another. Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content. It's also called placeholder (or filler) text. It's a convenient tool for mock-ups. It helps to outline the visual elements of a document or presentation, eg typography, font, or layout.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
                textAlign: TextAlign.start,
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 10.0, left: 20.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Color(0xff73aef5),
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans',
                    decoration: TextDecoration.underline,
                    letterSpacing: 1.0,
                    decorationThickness: 2.0
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Read more',
                      recognizer: TapGestureRecognizer()..onTap = () => print('something'),
                    )
                  ]
                ),
              )
            ),

            //todo: buttons
            Container(
              padding: EdgeInsets.only(top: 40.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: (){},
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.arrowAltCircleUp, color: Color(0xff73aef5), size: 18.0),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('Agree',
                            style: TextStyle(
                              color: Color(0xff73aef5),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: 1.0,
                    height: 30.0,
                    color: Colors.grey,
                  ),

                  InkWell(
                    onTap: (){},
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.arrowAltCircleDown, color: Color(0xff73aef5), size: 18.0),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('Disagree',
                            style: TextStyle(
                                color: Color(0xff73aef5),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: 1.0,
                    height: 30.0,
                    color: Colors.grey,
                  ),

                  InkWell(
                    onTap: (){},
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.comment, color: Color(0xff73aef5), size: 18.0),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('Comment',
                            style: TextStyle(
                                color: Color(0xff73aef5),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

        Fade(
          duration: Duration(milliseconds: 400),
          visible: disAg,
          child: Container(
            color: Color(0xffEF405B).withOpacity(0.4),
          ),
        ),

        Fade(
          duration: Duration(milliseconds: 400),
          visible: Ag,
          child: Container(
            color: Color(0xff18d26e).withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}