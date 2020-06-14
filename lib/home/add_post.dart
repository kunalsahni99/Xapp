import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xapp/home/further_info.dart';

import '../utils/prefs.dart';
import '../utils/fade_in.dart';
import '../transitions/slide_left_route.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xff73aef5)
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff73aef5),
          elevation: 10.0,
          leading: IconButton(
            icon: Icon(LineIcons.close, color: Colors.white, size: 30.0),
            onPressed: () => Navigator.pop(context),
          ),

          title: Text('Create Post',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),

          actions: <Widget>[
            InkWell(
              onTap: () => Navigator.push(context, SlideLeftRoute(page: FurtherInfo())),
              child: Container(
                width: 70.0,
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text('Skip',
                        style: TextStyle(
                            color: Color(0xff73aef5)
                        ),
                      ),
                    ),

                    Icon(Icons.arrow_forward_ios,
                      size: 10.0,
                      color: Color(0xff73aef5),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: (){

              },
              child: FadeIn(
                delay: 1.33,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 2.0,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10.0),
                    child: Center(child: Icon(FontAwesomeIcons.image, size: 40.0)),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
                ),
              ),
            ),

            FadeIn(
              delay: 1.66,
              child: Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: RaisedButton(
                  padding: EdgeInsets.only(left: 60.0, right: 60.0, top: 10.0, bottom: 10.0),
                  child: Text('Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0
                    ),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  color: Color(0xff73aef5),
                  onPressed: (){
                    //todo: pass selected fill here
                    Navigator.push(context, SlideLeftRoute(page: FurtherInfo()));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
