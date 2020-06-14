import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/valley_quad_curve.dart';
import '../transitions/slide_top_route.dart';
import 'comments.dart';

class ReadMore extends StatefulWidget {
  final String pUrl, uName, picUrl, title, desc, id;
  final int ag, disAg;
  final dynamic comments;

  ReadMore({
    this.uName,
    this.picUrl,
    this.pUrl,
    this.disAg,
    this.title,
    this.ag,
    this.desc,
    this.comments,
    this.id
  });

  @override
  _ReadMoreState createState() => _ReadMoreState();
}

class _ReadMoreState extends State<ReadMore> {
  bool isAgTapped = false, isDisAgTapped = false;
  int comLength = 0;

  @override
  void initState() {
    super.initState();
    widget.comments.keys.forEach((id){
      comLength += widget.comments[id]['comment'].length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff73aef5),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 40.0),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Post',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),

      body: ListView(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget.pUrl),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(widget.uName,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),

          Hero(
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
              tag: widget.id,
            child: CachedNetworkImage(imageUrl: widget.picUrl)
          ),

          Padding(
            padding: EdgeInsets.only(left: 10.0, top: 5.0),
            child: Text(widget.title,
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
            child: Text(widget.desc,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
              textAlign: TextAlign.start,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(isAgTapped ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp,
                      color: isAgTapped ? Color(0xff73aef5) : Colors.black),
                    onPressed: (){
                      setState((){
                        isAgTapped = !isAgTapped;
                        if (isDisAgTapped){
                          isDisAgTapped = !isDisAgTapped;
                        }
                      });
                    },
                  ),

                  Text(widget.ag >= 1000 ? (widget.ag / 1000.0).toString() + 'k' : widget.ag.toString(),
                  )
                ],
              ),

              Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(isDisAgTapped ? FontAwesomeIcons.solidThumbsDown : FontAwesomeIcons.thumbsDown,
                        color: isDisAgTapped ? Color(0xff73aef5) : Colors.black),
                    onPressed: (){
                      setState((){
                        isDisAgTapped = !isDisAgTapped;
                        if (isAgTapped){
                          isAgTapped = !isAgTapped;
                        }
                      });
                    },
                  ),

                  Text(widget.disAg >= 1000 ? (widget.disAg / 1000.0).toString() + 'k' : widget.disAg.toString(),
                  )
                ],
              ),

              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Color(0xff73aef5),
                child: Row(
                  children: <Widget>[
                    Text('Comments',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                      ),
                    ),

                    //todo: length of comments on this post
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(comLength.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                        ),
                      ),
                    )
                  ],
                ),
                onPressed: (){
                  Navigator.push(context, SlideTopRoute(page: Comments(
                    comments: widget.comments,
                    agree: widget.ag,
                    disAgree: widget.disAg,
                    postID: widget.id,
                  )));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}