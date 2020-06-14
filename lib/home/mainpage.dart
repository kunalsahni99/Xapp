import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fade/fade.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progressive_image/progressive_image.dart';

import '../transitions/ripple_right_up.dart';
import 'read_more.dart';
import 'search.dart';
import 'profile.dart';
import 'comments.dart';
import '../transitions/slide_top_route.dart';
import 'add_post.dart';
import '../utils/app_bar.dart';
import '../utils/valley_quad_curve.dart';
import 'photo_details.dart';

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
      value: SystemUiOverlayStyle(statusBarColor: Color(0xff73aef5)),
      child: WillPopScope(
          onWillPop: _onWillPopScope,
          child: Scaffold(
            appBar: TopBar(title: 'WhyyU'),
            body: StreamBuilder<QuerySnapshot>(
                //todo: add where() here to get posts according to user's preferences
                stream: Firestore.instance.collection("posts").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 100.0),
                            child: SpinKitCircle(
                              color: Colors.black54,
                              size: 30.0,
                            )),
                      );
                    default:
                      return PageView(
                        controller: controller,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        children: snapshot.data.documents.map((document) {
                          return SinglePost(
                            title: document['title'],
                            desc: document['desc'],
                            uName: document['uName'],
                            postID: document['postID'],
                            pUrl: document['pUrl'],
                            picUrl: document['picUrl'],
                            category: document['category'],
                            agree: document['agree'],
                            disAgree: document['disagree'],
                            percentAgree: document['percent_agree'],
                            comments: document['comments'],
                          );
                        }).toList(),
                      );
                  }
                }),
            floatingActionButton: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 2),
                        blurRadius: 4.0)
                  ]),
              width: 100.0,
              height: 50.0,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              margin: EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                      onTap: () => Navigator.push(context,
                          RippleRightUp(page: Search(), isRightUp: true)),
                      child:
                          Icon(FontAwesomeIcons.search, color: Colors.white)),
                  Container(
                    width: 1.0,
                    height: 30.0,
                    color: Colors.white,
                  ),
                  InkWell(
                      onTap: () => Navigator.push(context,
                          RippleRightUp(page: AddPost(), isRightUp: true)),
                      child: Icon(FontAwesomeIcons.plus, color: Colors.white)),
                ],
              ),
            ),
          )),
    );
  }
}

class SinglePost extends StatefulWidget {
  final String postID, uName, pUrl, picUrl, title, desc, category;
  final int agree, disAgree, percentAgree;
  final dynamic comments;

  SinglePost(
      {this.title,
      this.desc,
      this.uName,
      this.pUrl, //todo: profile_pic of user
      this.category,
      this.picUrl, //todo: Url of picture of post
      this.agree,
      this.disAgree,
      this.percentAgree,
      this.postID,
      this.comments
  });

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> with SingleTickerProviderStateMixin {
  TextPainter tp;
  TextSpan span;
  bool disAg = false, Ag = false;



  goToPost(){
    Navigator.push(context, SlideTopRoute(
        page: ReadMore(
          title: widget.title,
          desc: widget.desc,
          pUrl: widget.pUrl,
          picUrl: widget.picUrl,
          ag: widget.agree,
          disAg: widget.disAgree,
          uName: widget.uName,
          comments: widget.comments,
          id: widget.postID,
        )));
  }

  @override
  void initState() {
    super.initState();
    span = TextSpan(
      text: widget.desc,
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),
    );

    tp = TextPainter(
      text: span,
      maxLines: 6,
      textDirection: TextDirection.ltr
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        tp.layout(maxWidth: constraints.maxWidth);
        return Stack(
          children: <Widget>[
            GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dx > 0) {
                  //todo: right swipe
                  setState(() => Ag = true);
                  Timer(Duration(milliseconds: 500),
                          () => setState(() => Ag = false));
                } else if (details.delta.dx < 0) {
                  //todo: left swipe
                  setState(() => disAg = true);
                  Timer(Duration(milliseconds: 500),
                          () => setState(() => disAg = false));
                }
              },
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
                              backgroundImage:
                                  CachedNetworkImageProvider(widget.pUrl),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideTopRoute(
                                      page: Profile(
                                          uName: widget.uName,
                                          isViewedProfile: true)));
                            },
                            child: Text(
                              widget.uName,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsUp,
                                color: Colors.lightBlue, size: 20.0),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                widget.percentAgree.toString() + '%',
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
                          builder: (_) => PhotoDetails(pUrl: widget.picUrl,
                            title: widget.title,
                            id: widget.postID,
                            agree: widget.agree,
                            disagree: widget.disAgree,
                            comments: widget.comments,
                          )
                      ));
                    },
                    child: Hero(
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
                      tag: widget.postID,
                      child: ProgressiveImage(
                        placeholder: AssetImage('images/logo.png'),
                        fadeDuration: Duration(milliseconds: 1000),
                        thumbnail: NetworkImage(widget.picUrl),
                        image: NetworkImage(widget.picUrl),
                        width: MediaQuery.of(context).size.width,
                        height: constraints.maxHeight >= 660 ? 280.0 : 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //TODO: heading
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      widget.title,
                      maxLines: 2,
                      textAlign: TextAlign.start,
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
                      padding: EdgeInsets.only(left: 5.0, top: 10.0),
                      child: Text(
                        widget.desc,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 6,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),

                  tp.didExceedMaxLines ?
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
                  ) :
                  SizedBox(),

                  Spacer(),

                  //todo: buttons
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.thumbsUp,
                                  color: Color(0xff73aef5), size: 18.0),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Agree',
                                  style: TextStyle(
                                      color: Color(0xff73aef5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 1.0,
                          height: 50.0,
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
                                child: Text(
                                  'Disagree',
                                  style: TextStyle(
                                      color: Color(0xff73aef5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 1.0,
                          height: 50.0,
                          color: Colors.grey,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                              SlideTopRoute(page: Comments(
                                    comments: widget.comments,
                                    disAgree: widget.disAgree,
                                    agree: widget.agree,
                                    postID: widget.postID,
                                  )
                              )
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.commentAlt,
                                  color: Color(0xff73aef5), size: 18.0),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Comment',
                                  style: TextStyle(
                                      color: Color(0xff73aef5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
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
      },
    );
  }
}
