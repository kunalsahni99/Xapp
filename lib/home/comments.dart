import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/valley_quad_curve.dart';
import '../transitions/slide_left_route.dart';
import '../utils/show_media.dart';
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
  VideoPlayerController controller;
  bool isSending = false, isLoading = true;
  var tempCom, tempUsers, comList = [], repList = [], l = [];
  String key, repKey, url, reply;
  int length = 0;
  TextEditingController textController = TextEditingController();
  dynamic keys = [];

  //todo: generates replies list for a comment
  //todo: change map[repKey]['on'] to map[repKey]['on']['${repList.indexOf(element)}']
  List<Widget> replies(dynamic map, BuildContext context, int index) {
    List<Widget> temp = [];
    repList = getList(map);
    repList.forEach((element) {
      repKey = element.keys.elementAt(0);
      if (map[repKey]['on']['${repList.indexOf(element)}'] == index) {
        temp.add(commentBubble(
            tempUsers[repKey]['pUrl'],
            tempUsers[repKey]['uName'],
            element[repKey],
            repKey,
            map[repKey]['isPicture']['${repList.indexOf(element)}'] == null ? false : true,
            false,
            index,
            isVideo: map[repKey]['isVideo']['${repList.indexOf(element)}'] == null ? false : true));
      }
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
  getLength(dynamic map) {
    map.keys.forEach((id) {
      length += map[id]['comment'].length;
    });
  }

  //todo: prepares list of comments/replies
  List getList(dynamic map) {
    getLength(map);
    List list = List(length);
    map.keys.forEach((id) {
      map[id]['comment'].forEach((index, val) {
        list[int.parse(index)] = {id: val};
      });
    });
    length = 0;
    return list;
  }

  Future<String> showBottomSheet(bool isImage) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 2),
                    height: 5.0,
                    width: 100.0,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0),
                    child: Text(
                      isImage ? 'Select image using' : 'Select video using',
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.cameraRetro,
                        size: 30.0, color: Colors.black54),
                    title: Text('Camera'),
                    onTap: () async {
                      //todo: open camera
                      url = await Utils().getUrl(context, true, isImage);
                      if (url != null) {
                        if (!keys.contains('0001')) {
                          tempUsers['0001'] = {
                            'uName': 'IamKSahni',
                            'pUrl':
                                'https://firebasestorage.googleapis.com/v0/b/xapp-5775a.appspot.com/o/users%2F0001%2Fmypic.jpg?alt=media&token=e5b6a9c1-c997-4414-bab4-97d7b9fa281f'
                          };
                        }
                        addToList(false, isImage: isImage);
                      }
                      return 'Done';
                    },
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.solidImages,
                        size: 30.0, color: Colors.black54),
                    title: Text('Gallery'),
                    onTap: () async {
                      //todo: open gallery
                      url = await Utils().getUrl(context, false, isImage);
                      if (url != null) {
                        if (!keys.contains('0001')) {
                          tempUsers['0001'] = {
                            'uName': 'IamKSahni',
                            'pUrl':
                                'https://firebasestorage.googleapis.com/v0/b/xapp-5775a.appspot.com/o/users%2F0001%2Fmypic.jpg?alt=media&token=e5b6a9c1-c997-4414-bab4-97d7b9fa281f'
                          };
                        }
                        addToList(false, isImage: isImage);
                      }
                      return 'Done';
                    },
                  ),
                ],
              ),
            ));
    return Future.value('Nothing');
  }

  //todo: if isComment == true, then comList will be updated, else repList will be updated
  addToList(bool isText, {bool isImage, bool isComment = true, String key, int index}) {
    //todo: if func is called by comment page, update comList, else update repList
    if (isComment){
      l = [];
      l.addAll(comList);
      //todo: add userID from SharedPreferences
      l.add({'0001': isText ? textController.text : url});
      comList = List(l.length);
      comList = l;

      if (tempCom.isNotEmpty) {
        if (isText) {
          tempCom['0001']['comment']
              .addAll({'${comList.length - 1}': textController.text});
        } else {
          tempCom['0001']['comment'].addAll({
            '${comList.length - 1}': url,
          });
          if (isImage) {
            tempCom['0001']['isPicture'].addAll({'${comList.length - 1}': true});
          } else {
            tempCom['0001']['isVideo'].addAll({'${comList.length - 1}': true});
          }
        }
      } else {
        if (isText) {
          tempCom['0001'] = {
            'comment': {'${comList.length - 1}': textController.text},
            'isPicture': {},
            'isVideo': {},
            'replies': {}
          };
        } else {
          if (isImage) {
            tempCom['0001'] = {
              'comment': {
                '${comList.length - 1}': url,
              },
              'isPicture': {'${comList.length - 1}': true},
              'isVideo': {},
              'replies': {}
            };
          } else {
            tempCom['0001'] = {
              'comment': {
                '${comList.length - 1}': url,
              },
              'isPicture': {},
              'isVideo': {'${comList.length - 1}': true},
              'replies': {}
            };
          }
        }
      }
    }
    else{
      l = [];
      l.addAll(repList);
      //todo: add userID from SharedPreferences
      l.add({'0001': reply});
      repList = List(l.length);
      repList = l;

      if (tempCom[key]['replies'].isNotEmpty) {
        if (isText) {
          tempCom[key]['replies']['0001']['comment']
              .addAll({'${repList.length - 1}': reply});
        } else {
          tempCom[key]['replies']['0001']['comment'].addAll({
            '${repList.length - 1}': reply,
          });
          if (isImage) {
            tempCom[key]['replies']['0001']['isPicture'].addAll({'${repList.length - 1}': true});
          } else {
            tempCom[key]['replies']['0001']['isVideo'].addAll({'${repList.length - 1}': true});
          }
        }
        tempCom[key]['replies']['0001']['on'].addAll({
          '${repList.length - 1}' : index
        });
      } else {
        if (isText) {
          tempCom[key]['replies'] = {
            '0001': {
              'comment': {'${repList.length - 1}': reply},
              'isPicture': {},
              'isVideo': {},
              'on': {
                '${repList.length - 1}' : index
              }
            }
          };
        } else {
          if (isImage) {
            tempCom[key]['replies'] = {
              '0001': {
                'comment': {
                  '${repList.length - 1}': reply,
                },
                'isPicture': {'${repList.length - 1}': true},
                'isVideo': {},
                'on': {
                  '${repList.length - 1}' : index
                }
              }
            };
          } else {
            tempCom[key]['replies'] = {
              '0001': {
                'comment': {
                  '${repList.length - 1}': reply,
                },
                'isPicture': {},
                'isVideo': {'${repList.length - 1}': true},
                'on': {
                  '${repList.length - 1}' : index
                }
              }
            };
          }
        }
      }
    }

    Firestore.instance
        .collection('posts')
        .document(widget.postID)
        .updateData({'comments': tempCom});
  }

  //todo: key is the userID of the comment
  Widget commentBubble(String pUrl, String uName, String comment, String key,
      bool isPicture, bool isComment, int index, {bool isVideo}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0, top: isComment ? 0.0 : 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: isComment ? 30.0 : 20.0,
            backgroundImage: CachedNetworkImageProvider(pUrl),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: !isPicture && comment.length <= 70
                    ? 150.0
                    : isVideo ? 150.0 : MediaQuery.of(context).size.width / 2,
                margin: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, left: 8.0, bottom: 10.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        uName,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      isPicture
                          ? Center(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 5.0),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                          page: ShowMedia(
                                              url: comment, isImage: true))),
                                  child: Hero(
                                    tag: comment,
                                    flightShuttleBuilder:
                                        (BuildContext flightContext,
                                            Animation<double> animation,
                                            HeroFlightDirection flightDirection,
                                            BuildContext fromHeroContext,
                                            BuildContext toHeroContext) {
                                      final Hero toHero = toHeroContext.widget;

                                      return FadeTransition(
                                        opacity: animation.drive(
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .chain(CurveTween(
                                                  curve: Interval(0.0, 1.0,
                                                      curve:
                                                          ValleyQuadraticCurve()))),
                                        ),
                                        child: toHero.child,
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      placeholder: (context, val) {
                                        return Center(
                                          child: SpinKitChasingDots(
                                            color: Colors.lightBlue,
                                            size: 40.0,
                                          ),
                                        );
                                      },
                                      imageUrl: comment,
                                      height:
                                          MediaQuery.of(context).size.width /
                                              1.5,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : isVideo
                              ? InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                          page: ShowMedia(
                                              url: comment, isImage: false))),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      children: [
                                        Icon(FontAwesomeIcons.play,
                                            color: Colors.black, size: 20.0),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            'Video',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Text(comment),
                    ],
                  ),
                ),
              ),
              isComment ?
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () async{
                      var rep = await Navigator.push(context, MaterialPageRoute(
                        builder: (_) => Reply(
                          pUrl: pUrl,
                          uName: uName,
                          comment: comment,
                          isPicture: isPicture,
                          isVideo: isVideo,
                        )
                      ));

                      if (rep['reply'] != null){
                        repList = tempCom[key]['replies'] != null ? getList(tempCom[key]['replies']) : [];
                        setState(() {
                          reply = rep['reply'];
                          addToList(!rep['isPicture'] && !rep['isVideo'] ? true : false,
                            isComment: false,
                            isImage: rep['isPicture'],
                            key: key,
                            index: index
                          );
                        });
                      }
                    },
                    child: Text(
                      'Reply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ) :
                SizedBox(width: 0.0, height: 0.0),
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
      comList = getList(tempCom);
    }

    Timer(Duration(milliseconds: 2000), () {
      setState(() => isLoading = false);
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
      body: !isLoading
          ? Stack(
              children: <Widget>[
                tempCom.isNotEmpty
                    ? ListView.builder(
                        itemCount: comList.length,
                        padding: EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 60.0),
                        itemBuilder: (context, index) {
                          key = comList[index].keys.elementAt(0);
                          return tempCom[key]['replies'] != null
                              ? Column(
                                  children: [
                                    commentBubble(
                                        tempUsers[key]['pUrl'],
                                        tempUsers[key]['uName'],
                                        comList[index][key],
                                        key,
                                        tempCom[key]['isPicture']['$index'] == null ? false : true,
                                        true,
                                        index,
                                        isVideo: tempCom[key]['isVideo']['$index'] == null ? false : true),
                                    Padding(
                                      padding: EdgeInsets.only(left: 80.0),
                                      child: Column(
                                          children: replies(
                                              tempCom[key]['replies'],
                                              context,
                                              index)),
                                    )
                                  ],
                                )
                              : commentBubble(
                                  tempUsers[key]['pUrl'],
                                  tempUsers[key]['uName'],
                                  comList[index][key],
                                  key,
                                  tempCom[key]['isPicture']['$index'] == null ? false : true,
                                  true,
                                  index,
                                  isVideo: tempCom[key]['isVideo']['$index'] == null ? false : true);
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
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 18.0),
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
                    decoration: Utils().boxDecoration,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          border: Utils().outlineInputBorder,
                          enabledBorder: Utils().enabledBorder,
                          focusedBorder: Utils().enabledBorder,
                          hintText: 'Write a comment...',
                          filled: true,
                          contentPadding: EdgeInsets.only(top: 2.0, left: 10.0),
                          fillColor: Colors.black.withOpacity(0.1),
                          suffixIcon: isSending
                              ? IconButton(
                                  icon: Icon(Icons.send,
                                      color: Color(0xff73aef5), size: 30.0),
                                  onPressed: () {
                                    setState(() {
                                      //todo: get uName and pUrl from SharedPreferences
                                      if (!keys.contains('0001')) {
                                        tempUsers['0001'] = {
                                          'uName': 'IamKSahni',
                                          'pUrl':
                                              'https://firebasestorage.googleapis.com/v0/b/xapp-5775a.appspot.com/o/users%2F0001%2Fmypic.jpg?alt=media&token=e5b6a9c1-c997-4414-bab4-97d7b9fa281f'
                                        };
                                      }
                                      addToList(true);
                                      textController.text = "";
                                      isSending = false;
                                    });
                                  },
                                )
                              : Wrap(
                                  children: [
                                    IconButton(
                                        icon: Icon(FontAwesomeIcons.cameraRetro,
                                            color: Color(0xff73aef5),
                                            size: 30.0),
                                        onPressed: () async {
                                          showBottomSheet(true).then((value) {
                                            if (value == 'Done') {
                                              Navigator.pop(context);
                                            }
                                          });
                                        }),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: IconButton(
                                          icon: Icon(FontAwesomeIcons.video,
                                              color: Color(0xff73aef5),
                                              size: 30.0),
                                          onPressed: () async {
                                            showBottomSheet(false)
                                                .then((value) {
                                              if (value == 'Done') {
                                                Navigator.pop(context);
                                              }
                                            });
                                          }),
                                    )
                                  ],
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
            )
          : Utils().loadingScreen(),
    );
  }
}

class Reply extends StatefulWidget {
  final String pUrl, uName, comment;
  final bool isPicture, isVideo;

  Reply({this.comment, this.pUrl, this.uName, this.isPicture, this.isVideo});

  @override
  _ReplyState createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  bool isSending = true, focus = false, isPicture = false, isVideo = false;
  final TextEditingController replyController = TextEditingController();
  String reply;
  dynamic repInfo = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      replyController.text = widget.uName;
      focus = true;
    });
  }

  void showBottomSheet(bool isImage) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 2),
                height: 5.0,
                width: 100.0,
              ),
              Padding(
                padding:
                EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0),
                child: Text(
                  isImage ? 'Select image using' : 'Select video using',
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.cameraRetro,
                    size: 30.0, color: Colors.black54),
                title: Text('Camera'),
                onTap: () async {
                  //todo: open camera
                  reply = await Utils().getUrl(context, true, isImage);

                  setState(() {
                    isPicture = isImage;
                    isVideo = !isImage;

                    repInfo['reply'] = reply;
                    repInfo['isPicture'] = isPicture;
                    repInfo['isVideo'] = isVideo;
                  });
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.solidImages,
                    size: 30.0, color: Colors.black54),
                title: Text('Gallery'),
                onTap: () async {
                  //todo: open gallery
                  reply = await Utils().getUrl(context, false, isImage);

                  setState(() {
                    isPicture = isImage;
                    isVideo = !isImage;

                    repInfo['reply'] = reply;
                    repInfo['isPicture'] = isPicture;
                    repInfo['isVideo'] = isVideo;
                  });
                },
              ),
            ],
          ),
        ));
  }

  Widget replyBubble(String pUrl, String uName, String reply, bool isComment,
      bool isPicture, {bool isVideo = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: isComment ? 30.0 : 20.0,
            backgroundImage: CachedNetworkImageProvider(pUrl),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: !isPicture && reply.length <= 70
                    ? 150.0
                    : isVideo ? 150.0 : MediaQuery.of(context).size.width / 2,
                margin: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, left: 8.0, bottom: 10.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        uName,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      isPicture
                          ? Center(
                        child: Padding(
                          padding:
                          EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                SlideLeftRoute(
                                    page: ShowMedia(
                                        url: reply, isImage: true))),
                            child: Hero(
                              tag: reply,
                              flightShuttleBuilder:
                                  (BuildContext flightContext,
                                  Animation<double> animation,
                                  HeroFlightDirection flightDirection,
                                  BuildContext fromHeroContext,
                                  BuildContext toHeroContext) {
                                final Hero toHero = toHeroContext.widget;

                                return FadeTransition(
                                  opacity: animation.drive(
                                    Tween<double>(begin: 0.0, end: 1.0)
                                        .chain(CurveTween(
                                        curve: Interval(0.0, 1.0,
                                            curve:
                                            ValleyQuadraticCurve()))),
                                  ),
                                  child: toHero.child,
                                );
                              },
                              child: CachedNetworkImage(
                                placeholder: (context, val) {
                                  return Center(
                                    child: SpinKitChasingDots(
                                      color: Colors.lightBlue,
                                      size: 40.0,
                                    ),
                                  );
                                },
                                imageUrl: reply,
                                height:
                                MediaQuery.of(context).size.width /
                                    1.5,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                      : isVideo
                          ? InkWell(
                        onTap: () => Navigator.push(
                            context,
                            SlideLeftRoute(
                                page: ShowMedia(
                                    url: reply, isImage: false))),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.play,
                                  color: Colors.black, size: 20.0),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      : Text(reply),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, repInfo);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            padding: EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.0)),
            width: MediaQuery.of(context).size.width,
            height: 80.0,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                      Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back,
                      color: Colors.grey),
                  onPressed: (){
                    Navigator.pop(context, repInfo);
                  },
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
                    replyBubble(widget.pUrl, widget.uName, widget.comment, true, widget.isPicture, isVideo: widget.isVideo),
                    Padding(
                      padding: EdgeInsets.only(left: 80.0),
                      child: reply != null ?
                          replyBubble('https://firebasestorage.googleapis.com/v0/b/xapp-5775a.appspot.com/o/users%2F0001%2Fmypic.jpg?alt=media&token=e5b6a9c1-c997-4414-bab4-97d7b9fa281f',
                              'IamKSahni', reply, false,  isPicture, isVideo: isVideo) : SizedBox(width: 0.0, height: 0.0),
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
                decoration: Utils().boxDecoration,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: replyController,
                    autofocus: focus,
                    decoration: InputDecoration(
                        border: Utils().outlineInputBorder,
                        enabledBorder: Utils().enabledBorder,
                        focusedBorder: Utils().enabledBorder,
                        hintText: 'Write a reply...',
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 2.0, left: 10.0),
                        fillColor: Colors.black.withOpacity(0.1),
                        suffixIcon: isSending
                            ? IconButton(
                                icon: Icon(Icons.send,
                                    color: Color(0xff73aef5), size: 30.0),
                                onPressed: () {
                                  if (reply == null){
                                    setState((){
                                      reply = replyController.text;
                                      replyController.text = "";
                                      isSending = false;

                                      repInfo['reply'] = reply;
                                      repInfo['isPicture'] = false;
                                      repInfo['isVideo'] = false;
                                    });
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: 'Replies can be added one at a time');
                                  }
                                },
                              )
                            : Wrap(
                                children: [
                                  IconButton(
                                    icon: Icon(FontAwesomeIcons.cameraRetro,
                                      color: Color(0xff73aef5), size: 30.0),
                                    onPressed: (){
                                      if (reply == null){
                                        showBottomSheet(true);
                                      }
                                      else{
                                        Fluttertoast.showToast(msg: 'Replies can be added one at a time');
                                      }
                                    }
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: IconButton(
                                      icon: Icon(FontAwesomeIcons.video,
                                        color: Color(0xff73aef5), size: 30.0),
                                      onPressed: () async{
                                        if (reply == null){
                                          showBottomSheet(false);
                                        }
                                        else{
                                          Fluttertoast.showToast(msg: 'Replies can be added one at a time');
                                        }
                                      }
                                    ),
                                  )
                                ],
                              )),
                    onChanged: (val) {
                      val.length == 0 ? setState(() => isSending = false) : setState(() => isSending = true);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}