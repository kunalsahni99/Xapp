import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../transitions/slide_top_route.dart';
import '../utils/valley_quad_curve.dart';
import 'comments.dart';
import '../utils/prefs.dart';

class PhotoDetails extends StatefulWidget {
  final String pUrl, title, id;
  final dynamic comments;
  final int agree, disagree;

  PhotoDetails({this.pUrl, this.title, this.id, this.comments, this.agree, this.disagree});

  @override
  _PhotoDetailsState createState() => _PhotoDetailsState();
}

class _PhotoDetailsState extends State<PhotoDetails> {
  bool visible = true;

  Widget opacityWidget(Widget child){
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: visible ? 1.0 : 0.0,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.black87
      ),
      child: GestureDetector(
        onTap: (){
          setState(() => visible = !visible);
        },
        child: Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: opacityWidget(
              IconButton(
                icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
                onPressed: !visible ? null : () => Navigator.pop(context),
              )
            ),

            title: opacityWidget(
              Text(widget.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              )
            ),

            actions: <Widget>[
              opacityWidget(
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white, size: 30.0),
                  onPressed: !visible ? null : () => showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                       height: 150.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
                              height: 5.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5.0)
                              ),
                            ),

                            ListTile(
                              leading: Icon(FontAwesomeIcons.download, color: Colors.black54),
                              title: Text('Save to Phone',

                              ),
                              onTap: (){},
                            ),

                            ListTile(
                              leading: Icon(FontAwesomeIcons.share, color: Colors.black54),
                              title: Text('Share',

                              ),
                              onTap: (){},
                            )
                          ],
                        ),
                      )
                  ),
                )
              ),
            ],
          ),

          body: Center(
            child: PhotoView(
              tightMode: true,
              heroAttributes: PhotoViewHeroAttributes(
                flightShuttleBuilder: (BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext){
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
              ),
              minScale: 0.0,
              maxScale: 5.0,
              imageProvider: CachedNetworkImageProvider(widget.pUrl),
            ),
          ),

          bottomNavigationBar: opacityWidget(
            Container(
              height: 80.0,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    alignment: Alignment.centerRight,
                    //todo: length of comments on this post
                    child: Text('10 comments',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10.0),
                    child: Divider(color: Colors.white, ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: !visible ? null : (){},
                        child: Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsUp, color: Colors.white),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text('Agree',
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      InkWell(
                        onTap: !visible ? null : (){},
                        child: Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsDown, color: Colors.white),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text('Disagree',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      InkWell(
                        onTap: !visible ? null : () => Navigator.push(context,
                            SlideTopRoute(page: Comments(
                              comments: widget.comments,
                              agree: widget.agree,
                              disAgree: widget.disagree,
                              postID: widget.id,
                        ))),
                        child: Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.commentAlt, color: Colors.white),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text('Comment',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}

