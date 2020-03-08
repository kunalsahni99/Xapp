import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../utils/prefs.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController controller;
  List<String> userPrefs = ['Sports',
    'Music',
    'Games',
    'Science & Technology',
    'Food', 'Memes',
    'Politics',
    'Politics',
    'Politics',
    'Politics',
    'Politics', 'Politics', 'Politics', 'Politics(Indian)'];

  @override
  void initState() {
    super.initState();
    controller = TabController(
        length: 2,
        vsync: this
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget bioUI() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 10.0),
        children: <Widget>[
          Text(
            "Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('My Preferences',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.edit, color: Color(0xff73aef5), size: 25.0),
                  onPressed: () {
                    //todo: edit preference list
                  },
                )
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 10.0),
              shrinkWrap: true,
              itemCount: userPrefs.length,
              itemBuilder: (context, index) => prefsBubbles(userPrefs[index]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 0.75,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget prefsBubbles(String title) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Color(0xff73aef5),
      ),
      child: Text(title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget postsUI(){
    return Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 20, //todo: length of query snapshot
        padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
        itemBuilder: (context, index){
          return InkWell(
            onTap: (){
              //todo: open post details

            },
            child: Container(
              //todo: network image
              child: Image.asset('images/something.jpg',
                width: 20.0,
                height: 20.0,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isInnerBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(
                      50.0), bottomRight: Radius.circular(50.0))),
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xff73aef5),
              primary: false,
              pinned: true,
              floating: false,
              expandedHeight: MediaQuery.of(context).size.width + 50.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width + 50.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xff73aef5),
                                Color(0xff61a4f1),
                                Color(0xff478de0),
                                Color(0xff398ae5)
                              ],
                              stops: [0.1, 0.4, 0.7, 0.9]
                          ),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0)),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.powerOff,
                                      color: Colors.white, size: 25.0),
                                  onPressed: () {
                                    //todo: Logout function
                                  },
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 40.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Profile',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),

                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.white, size: 25.0,),
                                        onPressed: (){
                                          //todo: edit profile function
                                        },
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle
                                  ),
                                  child: IconButton(
                                    icon: Icon(Utils().retIOS()
                                        ? Icons.arrow_forward_ios
                                        : Icons.arrow_forward,
                                        color: Color(0xff73aef5),
                                        size: 25.0
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    //todo: add following
                                    Text('0',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0
                                      ),
                                    ),

                                    Text('Following',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0
                                      ),
                                    )
                                  ],
                                ),

                                Stack(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'images/pic.jpg'),
                                      radius: 60.0,
                                    ),

                                    Positioned(
                                      bottom: 0.0,
                                      right: 0.0,
                                      child: InkWell(
                                        onTap: () {
                                          //todo: change profile pic function

                                        },
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                              color: Color(0xff73aef5),
                                              shape: BoxShape.circle
                                          ),
                                          child: Icon(FontAwesomeIcons.plus,
                                              color: Colors.white, size: 20.0),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                Column(
                                  children: <Widget>[
                                    //todo: add followers
                                    Text('200',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0
                                      ),
                                    ),

                                    Text('Followers',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          //todo: username
                          Text('IamKSahni',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600
                            ),
                          ),

                          //todo: actual name
                          Text('Kunal Sahni',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),

                          Opacity(
                            opacity: 0.0,
                            child: Container(
                              height: 100.0,
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                labelColor: Colors.white,
                controller: controller,
                indicatorColor: Color(0xff73aef5),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.description, color: Colors.white),
                    text: 'Bio',),
                  Tab(icon: Icon(Icons.grid_on, color: Colors.white),
                      text: 'Posts')
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            bioUI(),
            postsUI()
          ],
        ),
      ),
    );
  }
}