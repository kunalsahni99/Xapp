import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'search.dart';
import '../utils/valley_quad_curve.dart';
import 'chat_screen.dart';
import '../transitions/slide_top_route.dart';
import '../transitions/ripple_right_up.dart';
import '../transitions/slide_left_route.dart';
import '../utils/prefs.dart';
import 'follow_list.dart';
import 'user_avatar.dart';

class Chats extends StatefulWidget {

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Color(0xff73aef5)
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: SafeArea(
            top: true,
            child: Container(
              height: 60.0,
              color: Color(0xff73aef5),
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),

                    Text('Inbox',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    IconButton(
                      icon: Icon(FontAwesomeIcons.search, color: Colors.white),
                      onPressed: (){
                        Navigator.push(context, RippleRightUp(page: Search(), isRightUp: false));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        body: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Divider(),
          ),
          itemBuilder: (context, index){
            return ListTile(
              onTap: (){
                Navigator.push(context, SlideLeftRoute(page: ChatScreen(uName: 'SarcasticKid', pUrl: 'images/pic1.jpg', isGroup: false)));
              },
              //todo: user avatar
              leading: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => UserAvatar(name: 'SarcasticKid', pUrl: 'images/pic1.jpg', tag: index)
                  ));
                },
                child: Hero(
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
                  tag: index,
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: AssetImage('images/pic1.jpg'),
                  ),
                ),
              ),
              //todo: user name
              title: Text('SarcasticKid',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),

              //todo: last chat
              subtitle: Text('Aur bhai pubg khele?',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black45
                ),
              ),

              //todo: no of unread chats
              trailing: Visibility(
                visible: index % 2 == 0 ? true : false,
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff73aef5),
                  ),
                  child: Center(
                    child: Text('$index',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context, SlideTopRoute(page: FollowList())),
          backgroundColor: Colors.lightBlue,
          child: Icon(FontAwesomeIcons.solidEnvelope, color: Colors.white),
        ),
      ),
    );
  }
}