import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../utils/prefs.dart';
import '../utils/show_media.dart';
import '../transitions/slide_left_route.dart';
import '../utils/valley_quad_curve.dart';

class Reply extends StatefulWidget {
  final String pUrl, uName, comment;
  final bool isPicture, isVideo;
  final Map<String, HighlightedWord> map;

  Reply(
      {this.comment,
      this.pUrl,
      this.uName,
      this.isPicture,
      this.isVideo,
      this.map});

  @override
  _ReplyState createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  bool isSending = false, focus = false, isPicture = false, isVideo = false;
  final TextEditingController replyController = TextEditingController();
  String reply;
  int index;
  List tagList = [];
  dynamic repInfo = {}, map = {};

  @override
  void initState() {
    super.initState();
    setState(() {
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

  Widget replyBubble(
      String pUrl, String uName, String reply, bool isComment, bool isPicture,
      {bool isVideo = false, Map<String, HighlightedWord> getMap}) {
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
                              : getMap != null
                                  ? TextHighlight(
                                      text: reply,
                                      words: getMap,
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'McLaren'),
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
      onWillPop: () {
        Navigator.pop(context, repInfo);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            padding: EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.withOpacity(0.2), width: 1.0)),
            width: MediaQuery.of(context).size.width,
            height: 80.0,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                      Utils().retIOS()
                          ? Icons.arrow_back_ios
                          : Icons.arrow_back,
                      color: Colors.grey),
                  onPressed: () {
                    Navigator.pop(context, repInfo);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 3.5),
                  child: Text(
                    'Replies',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                    replyBubble(widget.pUrl, widget.uName, widget.comment, true,
                        widget.isPicture,
                        isVideo: widget.isVideo, getMap: widget.map),
                    Padding(
                      padding: EdgeInsets.only(left: 80.0),
                      child: reply != null
                          ? replyBubble(
                              'https://firebasestorage.googleapis.com/v0/b/xapp-5775a.appspot.com/o/users%2F0001%2Fmypic.jpg?alt=media&token=e5b6a9c1-c997-4414-bab4-97d7b9fa281f',
                              'IamKSahni',
                              reply,
                              false,
                              isPicture,
                              isVideo: isVideo,
                              getMap: map.isNotEmpty ? map : null
                            )
                          : SizedBox(width: 0.0, height: 0.0),
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
                  child: TypeAheadField(
                    hideSuggestionsOnKeyboardHide: true,
                    direction: AxisDirection.up,
                    textFieldConfiguration: TextFieldConfiguration(
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
                                    if (reply == null) {
                                      setState(() {
                                        reply = replyController.text;
                                        replyController.text = "";
                                        isSending = false;

                                        repInfo['reply'] = reply;
                                        repInfo['isPicture'] = false;
                                        repInfo['isVideo'] = false;
                                        if (tagList.isNotEmpty){
                                          repInfo['list'] = tagList;
                                          map = Utils().retMap(context, tagList);
                                        }
                                      });
                                    } else {
                                      Fluttertoast.showToast(msg: 'Replies can be added one at a time');
                                    }
                                  },
                                )
                              : Wrap(
                                  children: [
                                    IconButton(
                                        icon: Icon(FontAwesomeIcons.cameraRetro,
                                            color: Color(0xff73aef5),
                                            size: 30.0),
                                        onPressed: () {
                                          if (reply == null) {
                                            showBottomSheet(true);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Replies can be added one at a time');
                                          }
                                        }),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: IconButton(
                                          icon: Icon(FontAwesomeIcons.video,
                                              color: Color(0xff73aef5),
                                              size: 30.0),
                                          onPressed: () async {
                                            if (reply == null) {
                                              showBottomSheet(false);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Replies can be added one at a time');
                                            }
                                          }),
                                    )
                                  ],
                                )),
                      onChanged: (val) {
                        val.length == 0
                            ? setState(() => isSending = false)
                            : setState(() => isSending = true);
                      },
                    ),
                    loadingBuilder: (context){
                      return Container(
                          height: 100.0,
                          child: Utils().loadingScreen()
                      );
                    },
                    noItemsFoundBuilder: (context){
                      return Container(
                        height: 60.0,
                        child: Center(
                          child: Text('No such user',
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                        ),
                      );
                    },
                    hideOnError: true,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(suggestion['pUrl']),
                        ),
                        title: Text(suggestion['uName']),
                      );
                    },
                    //todo: change little-bit of logic
                    suggestionsCallback: (pattern) async {
                      if (pattern[pattern.length-1] != ' '){
                        if (pattern.length > 1 && pattern[pattern.length-2] == '@'){
                          setState(() => index = pattern.length-2);
                          return await Utils().retSuggestions(pattern[index+1]);
                        }
                      }
                      return null;
                    },
                    onSuggestionSelected: (suggestion) {
                      String val = replyController.text.substring(0, index+1);
                      setState(() {
                        tagList.add(suggestion['uName']);
                        replyController.text = val + suggestion['uName'];
                      });
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
