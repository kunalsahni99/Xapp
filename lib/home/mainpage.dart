import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fade/fade.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'photo_details.dart';
import '../transitions/ripple_right_up.dart';
import '../utils/valley_quad_curve.dart';
import 'search.dart';
import 'profile.dart';
import 'read_more.dart';
import 'comments.dart';
import '../transitions/slide_top_route.dart';
import 'add_post.dart';
import '../utils/app_bar.dart';

bool disAg = false,
    Ag = false;

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Scaffold(
                appBar: TopBar(title: 'WhyyU'),
                body: PageView.builder(
                  itemCount: 10,
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      GestureDetector(
                        onPanUpdate: (details) {
                          if (details.delta.dx > 0) {
                            //todo: right swipe
                            setState(() => Ag = true);
                            Timer(
                                Duration(milliseconds: 500),
                                    () => setState(() => Ag = false)
                            );
                          }
                          else if (details.delta.dx < 0) {
                            //todo: left swipe
                            setState(() => disAg = true);
                            Timer(
                                Duration(milliseconds: 500),
                                    () => setState(() => disAg = false)
                            );
                          }
                        },
                        child: SinglePost(id: index),
                      ),
                ),

                floatingActionButton: Container(
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0, 2),
                            blurRadius: 4.0
                        )
                      ]
                  ),
                  width: 100.0,
                  height: 50.0,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                          onTap: () =>
                              Navigator.push(context, RippleRightUp(
                                  page: Search(), isRightUp: true)),
                          child: Icon(
                              FontAwesomeIcons.search, color: Colors.white)
                      ),

                      Container(
                        width: 1.0,
                        height: 30.0,
                        color: Colors.white,
                      ),

                      InkWell(
                          onTap: () =>
                              Navigator.push(context, RippleRightUp(
                                  page: AddPost(), isRightUp: true)),
                          child: Icon(
                              FontAwesomeIcons.plus, color: Colors.white)
                      ),
                    ],
                  ),
                ),
              );
            },
          )
      ),
    );
  }
}

class SinglePost extends StatefulWidget {
  final int id;

  SinglePost({this.id});

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost>
    with SingleTickerProviderStateMixin {

  goToPost(){
    Navigator.push(context, SlideTopRoute(
        page: ReadMore(
          //todo: give all these values dynamically
          title: "Some shitty thought you can\'t imagine",
          desc: "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used before final copy is available, but it may also be used to temporarily replace copy in a process called greeking, which allows designers to consider form without the meaning of the text influencing the design.Lorem ipsum is typically a corrupted version of De finibus bonorum et malorum, a first-century BCE text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical, improper Latin.",
          pUrl: 'images/pic.jpg',
          picUrl: 'images/something.jpg',
          ag: 5000,
          disAg: 1000,
          uName: 'IamKSahni',
        )));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: <Widget>[
            Container(
              height: constraints.maxHeight,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('images/pic.jpg'),
                            ),
                          ),

                          GestureDetector(
                            onTap: () =>
                                Navigator.push(context, SlideTopRoute(page: Profile(
                                    pUrl: 'images/pic.jpg',
                                    uName: 'IamKSahni',
                                    name: 'Kunal Sahni',
                                    bio: 'Fuckin Asshole',
                                    followers: '500',
                                    following: '250',
                                    isViewedProfile: true
                                ))),
                            child: Text('IamKSahni',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsUp, color: Colors.lightBlue,
                                size: 20.0),
                            //todo: find agree %age nd show it here
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text('69%',
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => PhotoDetails(pUrl: 'images/something.jpg',
                              title: 'Some shitty thought you can\'t imagine',
                              id: widget.id)
                      ));
                    },
                    child: Hero(
                      tag: widget.id,
                      flightShuttleBuilder: (BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext) {
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
                      child: Image.asset('images/something.jpg',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                        height: constraints.maxHeight > 720 ? 300 : 200,
                      ),
                    ),
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
                  GestureDetector(
                    onTap: () => goToPost(),
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        "No one gives a fuck to this post so scroll down, you'll find another. Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content. It's also called placeholder (or filler) text. It's a convenient tool for mock-ups. It helps to outline the visual elements of a document or presentation, eg typography, font, or layout. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                        maxLines: constraints.maxHeight > 720 ? 9 : 6,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),

                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 10.0, left: 20.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Colors.lightBlue,
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
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => goToPost(),
                              )
                            ]
                        ),
                      )
                  ),

                  Spacer(),

                  //todo: buttons
                  Container(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              Icon(
                                  FontAwesomeIcons.thumbsUp, color: Color(0xff73aef5),
                                  size: 18.0),
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
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.thumbsDown,
                                  color: Color(0xff73aef5), size: 18.0),
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
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Comments()));
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.commentAlt,
                                  color: Color(0xff73aef5), size: 18.0),
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
                color: Colors.green.withOpacity(0.3),
              ),
            ),
          ],
        );
      }
    );
  }
}