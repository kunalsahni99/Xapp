import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:line_icons/line_icons.dart';

import '../transitions/slide_left_route.dart';
import '../transitions/slide_right_route.dart';
import '../home/chats.dart';
import '../home/profile.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;

  TopBar({this.title}) : preferredSize = Size.fromHeight(60.0);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Card(
            color: Color(0xff73aef5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0)),
            ),
            elevation: 0.0,
            child: MaterialButton(
              height: 50,
              minWidth: 50,
              elevation: 0.0,
              onPressed: () => Navigator.push(context,SlideRightRoute(page: Profile(
                  pUrl: 'https://firebasestorage.googleapis.com/v0/b/xapp-5775a.appspot.com/o/users%2FWzajDLw4U5XYtoeQP01F5SW9tv32%2Fposts%2Fpost_null?alt=media&token=b222e090-a281-43f2-9068-8d5fe42502bc',
                  uName: 'SarcasticKid',
                  isViewedProfile: false
              ))),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))
              ),
              child: Icon(Icons.person_pin,
                color: Colors.white,
              ),
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0))
            ),
            elevation: 0.0,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.75,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
                color: Color(0xff73aef5)
              ),
              child: Text(title,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),

          Card(
            color: Color(0xff73aef5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0)),
            ),
            elevation: 0.0,
            child: MaterialButton(
              height: 50,
              minWidth: 50,
              elevation: 10,
              onPressed: () => Navigator.push(context, SlideLeftRoute(page: Chats())),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
              ),
              child: Icon(FontAwesomeIcons.envelope,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
