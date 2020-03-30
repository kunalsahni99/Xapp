import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../transitions/slide_left_route.dart';
import '../utils/prefs.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool isSending = false;
  var comments = {
    '0': {
      'uid': '0001',
      'comment' : 'Something',
      'replies': {
        '0005': 'Something',
        '0002': 'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.',
      }
    },

    '1': {
      'uid': '0002',
      'comment' : 'Something',
    },

    '2': {
      'uid': '0003',
      'comment': 'Awesome!!!',
      'replies': {
        '0004': 'Nicely done bro!!!',
        '0002': 'Lorem ipsum may be used before final copy is available, but it may also be used to temporarily replace copy in a process called greeking, which allows designers to consider form without the meaning of the text influencing the design.',
        '0003': 'Something'
      }
    },

    '3': {
      'uid': '0002',
      'comment' : 'Something',
    },
    '4': {
      'uid': '0002',
      'comment' : 'Something',
    },
    '5': {
      'uid': '0002',
      'comment' : 'Something',
    },
    '6': {
      'uid': '0002',
      'comment' : 'Something',
    },
    '7': {
      'uid': '0002',
      'comment' : 'Something',
    },
    '8': {
      'uid': '0002',
      'comment' : 'Something',
    },
    '9': {
      'uid': '0002',
      'comment' : 'Something',
    },
    '10': {
      'uid': '0002',
      'comment' : 'Something',
    },
    '11': {
      'uid': '0002',
      'comment' : 'Something',
    },
  };

  Widget commentBubble(String pUrl, String uName, String comment, bool isPicture, bool isComment){
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0, top: isComment ? 0.0 : 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: isComment ? 30.0 : 20.0,
            backgroundImage: AssetImage(pUrl),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: isPicture == false && comment.length <= 50 ? 150.0 : MediaQuery.of(context).size.width / 1.5,
                margin: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 8.0, bottom: 10.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(uName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      isPicture ? Image.asset(comment) : Text(comment),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: (){
                    //todo: pass the comment/reply whose reply button is being pressed
                    Navigator.push(context, SlideLeftRoute(page: Reply(
                      pUrl: pUrl,
                      uName: uName,
                      comment: comment,
                    )));
                  },
                  child: Text('Reply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1.0
            )
          ),
          width: MediaQuery.of(context).size.width,
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),

              Text('10',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Icon(FontAwesomeIcons.arrowAltCircleUp, color: Colors.green),
              ),

              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text('0',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Icon(FontAwesomeIcons.arrowAltCircleDown, color: Color(0xffEF405B)),
              ),
            ],
          ),
        ),
      ),
      
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: comments.length,
            padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 60.0),
            itemBuilder: (context, index){
              return Column(
                children: <Widget>[
                  //todo: this bubble is for comments
                  commentBubble('images/pic.jpg', 'Kunal Sahni', comments['$index']['comment'], false, true),
                  comments['$index']['replies'] != null ?
                      //todo: build reply bubble for each reply on each comment if exist
                      Padding(
                        padding: EdgeInsets.only(left: 80.0),
                        child: commentBubble('images/pic.jpg', 'Kunal Sahni', comments['$index']['uid'], false, false),
                      )
                      : SizedBox(width: 0.0, height: 0.0,)
                ],
              );
            },
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 0.0,
            height: 60.0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.lightBlue)
                )
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.white, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: 'Write a comment...',
                    filled: true,
                    contentPadding: EdgeInsets.only(top: 2.0, left: 10.0),
                    fillColor: Colors.black.withOpacity(0.1),
                    suffixIcon: isSending ?
                      IconButton(
                        icon: Icon(Icons.send, color: Color(0xff73aef5), size: 30.0),
                        onPressed: (){},
                      )  :
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: IconButton(
                          icon: Icon(FontAwesomeIcons.cameraRetro, color: Color(0xff73aef5), size: 30.0),
                          onPressed: (){},
                        ),
                      )
                  ),
                  onChanged: (val){
                    val.length == 0 ? setState(() => isSending = false) : setState(() => isSending = true);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Reply extends StatefulWidget {
  final String pUrl, uName, comment;

  Reply({this.comment, this.pUrl, this.uName});

  @override
  _ReplyState createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  bool isSending = false;
  bool focus = false;
  final TextEditingController replyController = TextEditingController();

  Widget commentBubble(String pUrl, String uName, String comment, bool isPicture, bool isComment){
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0, top: isComment ? 0.0 : 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: isComment ? 30.0 : 20.0,
            backgroundImage: AssetImage(pUrl),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: isPicture == false && comment.length <= 50 ? 150.0 : MediaQuery.of(context).size.width / 1.5,
                margin: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 8.0, bottom: 10.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(uName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      isPicture ? Image.asset(comment) : Text(comment),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      replyController.text = uName;
                      focus = true;
                    });
                  },
                  child: Text('Reply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      replyController.text = widget.uName;
      focus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1.0
              )
          ),
          width: MediaQuery.of(context).size.width,
          height: 80.0,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),

              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3.5),
                child: Text('Replies',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 60.0),
            children: <Widget>[
              Column(
                children: <Widget>[
                  commentBubble(widget.pUrl, widget.uName, widget.comment, false, true),
                  Padding(
                    padding: EdgeInsets.only(left: 80.0),
                    child: commentBubble('images/pic.jpg', 'IamKSahni', 'What\'s this?', false, false),
                  )
                ],
              ),
            ],
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 0.0,
            height: 60.0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1.0,
                      color: Colors.grey
                  )
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: TextField(
                  controller: replyController,
                  autofocus: focus,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      hintText: 'Write a reply...',
                      filled: true,
                      contentPadding: EdgeInsets.only(top: 2.0, left: 10.0),
                      fillColor: Colors.black.withOpacity(0.1),
                      suffixIcon: isSending ?
                      IconButton(
                        icon: Icon(Icons.send, color: Color(0xff73aef5), size: 30.0),
                        onPressed: (){},
                      )  :
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: IconButton(
                          icon: Icon(FontAwesomeIcons.cameraRetro, color: Color(0xff73aef5), size: 30.0),
                          onPressed: (){},
                        ),
                      )
                  ),
                  onChanged: (val){
                    val.length == 0 ? setState(() => isSending = false) : setState(() => isSending = true);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
