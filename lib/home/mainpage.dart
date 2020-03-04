import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: 'Whyyu'),
      body: PageView.builder(
        itemCount: 10,
        controller: controller,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => SinglePost(),
      )
    );
  }
}

class SinglePost extends StatefulWidget {
  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {

  @override
  Widget build(BuildContext context) {
    return Column(
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
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          child: Text("Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content. It's also called placeholder (or filler) text. It's a convenient tool for mock-ups. It helps to outline the visual elements of a document or presentation, eg typography, font, or layout.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
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
                fontFamily: 'Open Sans'
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Read more'
                )
              ]
            ),
          )
        )
      ],
    );
  }
}
