import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/prefs.dart';

class Comments extends StatefulWidget {
  final dynamic comments;
  final int agree, disAgree;
  final String postID;

  Comments({this.comments, this.disAgree, this.agree, this.postID});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool isSending = false, isLoading = true;
  var tempCom, tempUsers, comList, repList;
  String key, repKey;
  TextEditingController textController = TextEditingController();
  dynamic keys = [];

  List<Widget> replies(dynamic map, BuildContext context) {
    List<Widget> temp = [];
    map.forEach((repKey, val) {
      temp.add(Utils().commentBubble(
          tempUsers[repKey]['pUrl'],
          tempUsers[repKey]['uName'],
          map[repKey]['comment'],
          map[repKey]['isPicture'] == null ? false : true,
          false, context));
    });
    return temp;
  }

  //todo: updates tempUsers map with user details
  getData() {
    keys.forEach((userID) {
      Firestore.instance
          .collection('users')
          .document(userID)
          .get()
          .then((snapShot) {
        setState(() {
          tempUsers['$userID'] = {
            'uName': snapShot.data['username'],
            'pUrl': snapShot.data['profilePicture']
          };
        });
      });
    });
  }

  //todo: get the length of list of comments
  getLength(dynamic map){
    map.keys.forEach((id){

    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      tempCom = widget.comments;
      tempUsers = {};
    });

    if (tempCom.isNotEmpty) {
      tempCom.keys.forEach((id) {
        keys.add(id);
        if (tempCom[id]['replies'] != null) {
          tempCom[id]['replies'].keys.forEach((repID) {
            keys.add(repID);
          });
        }
      });

      setState(() => keys.toSet().toList());
      getData();


    }

    Timer(Duration(milliseconds: 1500), () {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return         Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
              border:
              Border.all(color: Colors.grey.withOpacity(0.2), width: 1.0)),
          width: MediaQuery.of(context).size.width,
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(
                    Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back,
                    color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                widget.agree.toString(),
                style:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Icon(FontAwesomeIcons.arrowAltCircleUp,
                    color: Colors.green),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.disAgree.toString(),
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Icon(FontAwesomeIcons.arrowAltCircleDown,
                    color: Color(0xffEF405B)),
              ),
            ],
          ),
        ),
      ),
      body: !isLoading ? Stack(
        children: <Widget>[
          tempCom.isNotEmpty
              ? ListView.builder(
            itemCount: tempCom.length,
            padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 60.0),
            itemBuilder: (context, index) {
              key = tempCom.keys.elementAt(index);
              return tempCom[key]['replies'] != null
                  ? Column(
                children: [
                  Utils().commentBubble(
                    tempUsers[key]['pUrl'],
                    tempUsers[key]['uName'],
                    tempCom[key]['comment'],
                    tempCom[key]['isPicture'] == null ? false : true,
                    true,
                    context
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 80.0),
                    child: Column(
                        children: replies(tempCom[key]['replies'], context)),
                  )
                ],
              )
                  : Utils().commentBubble(
                  tempUsers[key]['pUrl'],
                  tempUsers[key]['uName'],
                  tempCom[key]['comment'],
                  tempCom[key]['isPicture'] == null ? false : true,
                  true,
                  context
                );
            },
          )
              : Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 2),
            child: Column(
              children: [
                Icon(FontAwesomeIcons.solidComments,
                    color: Colors.grey, size: 100.0),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    'No comments yet.\nBe the first to comment...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                )
              ],
            ),
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
                      top: BorderSide(width: 1.0, color: Colors.lightBlue))),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                      const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: 'Write a comment...',
                    filled: true,
                    contentPadding: EdgeInsets.only(top: 2.0, left: 10.0),
                    fillColor: Colors.black.withOpacity(0.1),
                    suffixIcon: isSending ? IconButton(
                      icon: Icon(Icons.send,
                          color: Color(0xff73aef5), size: 30.0),
                      onPressed: () {
                          setState(() {
                            //todo: get uName and pUrl from SharedPreferences
                            if (!keys.contains('0001')){
                              tempUsers['0001'] = {
                                'uName': 'IamKSahni',
                                'pUrl': 'https://firebasestorage.googleapis.com/v0/b/xapp-5775a.appspot.com/o/users%2F0001%2Fmypic.jpg?alt=media&token=e5b6a9c1-c997-4414-bab4-97d7b9fa281f'
                              };
                            }
                            //todo: add userID from SharedPreferences
                            tempCom['0001'] = {
                              'comment': textController.text
                            };
                          });
                          Firestore.instance.collection('posts').document(widget.postID).updateData({
                            'comments': {
                              //todo: Here also
                              '0001': {
                                'comment': textController.text
                              }
                            }
                          });
                          setState(() {
                            textController.text = "";
                            isSending = false;
                          });
                      },
                    ) :
                    Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.cameraRetro, color: Color(0xff73aef5), size: 30.0),
                        onPressed: (){},
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    val.length == 0
                        ? setState(() => isSending = false)
                        : setState(() => isSending = true);
                  },
                ),
              ),
            ),
          ),
        ],
      ) :
      Utils().loadingScreen(),
    );
  }
}

class Reply extends StatefulWidget {
  final String pUrl, uName, comment;
  dynamic comments;

  Reply({this.comment, this.pUrl, this.uName, this.comments});

  @override
  _ReplyState createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  bool isSending = false;
  bool focus = false;
  final TextEditingController replyController = TextEditingController();

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
              border:
                  Border.all(color: Colors.grey.withOpacity(0.2), width: 1.0)),
          width: MediaQuery.of(context).size.width,
          height: 80.0,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                    Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back,
                    color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 3.5),
                child: Text(
                  'Replies',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                  Utils().commentBubble(
                      widget.pUrl, widget.uName, widget.comment, false, true, context),
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
                  border: Border.all(width: 1.0, color: Colors.grey)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: TextField(
                  controller: replyController,
                  autofocus: focus,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      hintText: 'Write a reply...',
                      filled: true,
                      contentPadding: EdgeInsets.only(top: 2.0, left: 10.0),
                      fillColor: Colors.black.withOpacity(0.1),
                      suffixIcon: isSending
                          ? IconButton(
                              icon: Icon(Icons.send,
                                  color: Color(0xff73aef5), size: 30.0),
                              onPressed: () {},
                            )
                          : Padding(
                              padding: EdgeInsets.only(right: 5.0),
                              child: IconButton(
                                icon: Icon(FontAwesomeIcons.cameraRetro,
                                    color: Color(0xff73aef5), size: 30.0),
                                onPressed: () {},
                              ),
                            )),
                  onChanged: (val) {
                    val.length == 0
                        ? setState(() => isSending = false)
                        : setState(() => isSending = true);
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