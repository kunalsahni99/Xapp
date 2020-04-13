import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';

import '../utils/prefs.dart';

class ChatScreen extends StatefulWidget {
  final String uName, pUrl; //todo: in case of group, uName is group name
  final bool isGroup;
  final List<Map<String, String>> participants; //todo: if isGroup is true, pass list of participants

  ChatScreen({this.uName, this.pUrl, this.isGroup, this.participants});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isNull = true, isLongPressed = false;
  ScrollController controller;
  TextEditingController textEditingController = TextEditingController();

  var chats = {
    '0': {
      'chat': 'Hello',
      'sender': true,
      'picture': false,
      'owner': 'SarcasticKid'
    },
    '1': {
      'chat': 'Hi!',
      'sender': true,
      'picture': false,
      'owner': '@zero'
    },
    '2': {
      'chat': 'Whats up?',
      'sender': false,
      'picture': false,
      'owner': 'You'
    },
    '3': {
      'chat': 'Nothing much',
      'sender': true,
      'picture': false,
      'owner': 'SarcasticKid'
    },
    '4': {
      'chat': 'Acha, r u free now?',
      'sender': false,
      'picture': false,
      'owner': 'You'
    },
    '5': {
      'chat': 'yes',
      'sender': true,
      'picture': false,
      'owner': 'SarcasticKid'
    },
    '6': {
      'chat': 'what happened!',
      'sender': true,
      'picture': false,
      'owner': 'SarcasticKid'
    },
    '7': {
      'chat': 'Itne vele ho',
      'sender': false,
      'picture': false,
      'owner': 'You'
    },
    '8': {
      'chat': 'toh jaake thaali baja na',
      'sender': false,
      'picture': false,
      'owner': 'You'
    },
    '9': {
      'chat': "No one gives a fuck to this post so scroll down, you'll find another. Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content. It's also called placeholder (or filler) text. It's a convenient tool for mock-ups. It helps to outline the visual elements of a document or presentation, eg typography, font, or layout.",
      'sender': true,
      'picture': false,
      'owner': '@zero'
    },
    '10': {
      'chat': '😛',
      'sender': true,
      'picture': false,
      'owner': 'SarcasticKid'
    },
    '11': {
      'chat': 'images/something.jpg',
      'sender': true,
      'picture': true,
      'owner': '@zero'
    },
    '12': {
      'chat': 'images/something.jpg',
      'sender': false,
      'picture': true,
      'owner': 'You'
    },
    '13': {
      'chat': 'Whats up?',
      'sender': false,
      'picture': false,
      'owner': 'You'
    },
    '14': {
      'chat': 'Im fine',
      'sender': true,
      'picture': false,
      'replyingChat': '13', //todo: the chatID on which the user is replying
      'replyOwner': 'You', //todo: owner of the chat on which user is replying
      'owner': 'SarcasticKid'
    },
    '15': {
      'chat': 'Can we meet?',
      'sender': true,
      'picture': false,
      'replyingChat': '14',
      'replyOwner': 'SarcasticKid',
      'owner': '@zero'
    },
    '16': {
      'chat': 'Yes, ofc',
      'sender': false,
      'picture': false,
      'replyingChat': '15',
      'replyOwner': 'You'
    },
  };

  void scrollDown(){
    Timer(Duration(milliseconds: 200),
        (){
          controller.jumpTo(controller.position.maxScrollExtent);
        }
    );
  }

  @override
  void initState() {
    super.initState();
    controller = new ScrollController();
    scrollDown();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var countState = Provider.of<Count>(context);
    FocusNode focusNode = FocusNode();

    return WillPopScope(
      onWillPop: (){
        if (countState.chatCount > 0){
          countState.setChatCount();
        }
        else{
          countState.setCount(0);
          countState.setList();
          countState.setChat(null);
          return Future.value(true);
        }
        countState.setChat(null);
        return Future.value(false);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Color(0xff73aef5)
        ),
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            backgroundColor: Color(0xff73aef5),
            leading: IconButton(
              icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
              onPressed: (){
                if (countState.chatCount > 0){
                  countState.setChatCount();
                }
                else{
                  countState.setCount(0);
                  countState.setList();
                  countState.setChat(null);
                  Navigator.pop(context);
                }
                countState.setChat(null);
              },
            ),
            title: countState.chatCount > 0 ?
                Container() :
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(widget.pUrl),
                      ),
                    ),

                    Text(widget.uName,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
            actions: <Widget>[
              countState.chatCount > 0 ?
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.reply,
                      color: countState.chatCount > 1 ? Color(0xff73aef5) : Colors.white,
                    ),
                    onPressed: countState.chatCount > 1 ? null : (){},
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.solidTrashAlt,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: countState.chatCount > 0 ? (){} : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: countState.chatCount > 0 ? (){} : null,
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: IconButton(
                      icon: Icon(Icons.reply,
                        color: Colors.white,
                      ),
                      onPressed: countState.chatCount > 0 ? (){} : null,
                    ),
                  ),
                ],
              ) :
              Container()
            ],
          ),

          body: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: chats.length,
                controller: controller,
                padding: EdgeInsets.only(bottom: 70.0, top: 10.0),
                itemBuilder: (context, index){
                  return SingleChatBubble(
                    isPicture: chats['$index']['picture'],
                    sender: chats['$index']['sender'],
                    text: chats['$index']['chat'],
                    id: '$index',
                    fNode: focusNode,
                    scrollController: controller,
                    replyingChat: chats['$index']['replyingChat'] != null ? chats[chats['$index']['replyingChat']]['chat'] : null,
                    replyOwner: chats['$index']['replyOwner'],
                    isReplyPicture: chats['$index']['replyingChat'] != null ? chats[chats['$index']['replyingChat']]['picture'] : false,
                    owner: widget.isGroup ? chats['$index']['owner'] : null,
                  );
                },
              ),

              Positioned.directional(
                textDirection: TextDirection.ltr,
                bottom: 0.0,
                height: 60.0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: textEditingController,
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
                        hintText: 'Type your message here',
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 2.0, left: 10.0),
                        fillColor: Colors.black.withOpacity(0.1),
                        suffixIcon: isNull ?
                        IconButton(
                          icon: Icon(Icons.photo_camera, color: Colors.lightBlue, size: 30.0),
                          onPressed: (){},
                        ) :
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.lightBlue, size: 30.0),
                          onPressed: (){
                            if (textEditingController.text.length > 0 && textEditingController.text != ' '){
                              if (countState.selectedChat != null){
                                setState(() {
                                  chats.addAll({
                                    '${chats.length}': {
                                      'chat': textEditingController.text,
                                      'sender': false,
                                      'picture': false,
                                      'replyingChat': countState.selectedChat,
                                      'replyOwner': chats['${countState.selectedChat}']['sender'] ?
                                          widget.isGroup ? chats['${countState.selectedChat}']['owner'] : widget.uName
                                          : 'You'
                                    }
                                  });
                                  countState.setChat(null);

                                  textEditingController.clear();
                                  isNull = true;
                                });
                              }
                              else{
                                setState((){
                                  chats.addAll({
                                    '${chats.length}': {
                                      'chat': textEditingController.text,
                                      'sender': false,
                                      'picture': false
                                    }
                                  });
                                  textEditingController.clear();
                                  isNull = true;
                                });
                              }
                              scrollDown();
                            }
                          },
                        ),
                    ),
                    onTap: (){
                      //todo: call this function when sending a message
                      Timer(
                        Duration(milliseconds: 500),
                        (){
                          controller.jumpTo(controller.position.maxScrollExtent);
                        }
                      );
                    },
                    focusNode: focusNode,
                    onChanged: (text){
                      text.length == 0 ? setState(() => isNull = true) : setState(() => isNull = false);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SingleChatBubble extends StatefulWidget {
  final String text, id, replyingChat, replyOwner, owner;
  final bool isPicture, sender, isReplyPicture; //todo: if the chat is a picture on which user is replying
  final FocusNode fNode;
  final ScrollController scrollController;

  SingleChatBubble({
    this.isPicture,
    this.sender,
    this.text,
    this.id,
    this.fNode,
    this.scrollController,
    this.replyingChat,
    this.replyOwner,
    this.isReplyPicture,
    this.owner
  });

  @override
  _SingleChatBubbleState createState() => _SingleChatBubbleState();
}

class _SingleChatBubbleState extends State<SingleChatBubble> with SingleTickerProviderStateMixin{
  bool isLongPressed = false, replied = false;
  double animatedPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    var countState = Provider.of<Count>(context);

    if (countState.chatCount == 0){
      setState(() => isLongPressed = false);
    }
    else if (countState.selectedChat == null){
      setState(() => replied = false);
    }

    return GestureDetector(
      onLongPress: (){
        if (!isLongPressed){
          setState(() => isLongPressed = true);
          countState.incChatCount();
        }
      },
      onTap: (){
        if (isLongPressed){
          setState(() => isLongPressed = false);
          countState.decChatCount();
        }
        else if (countState.chatCount > 0){
          setState(() => isLongPressed = true);
          countState.incChatCount();
        }
      },
      onDoubleTap: (){
        if (!replied){
          countState.setChat(widget.id);
          setState((){
            replied = true;
            animatedPadding = 50.0;
          });
          FocusScope.of(context).requestFocus(widget.fNode);
          Timer(
            Duration(milliseconds: 200),
            (){
              if (widget.scrollController.offset != widget.scrollController.position.maxScrollExtent){
                widget.scrollController.jumpTo(widget.scrollController.offset + 5.0);
              }
            }
          );
        }
        else if (countState.selectedChat != widget.id){
          setState(() => replied = false);
        }
      },
      child: Container(
        color: isLongPressed ? Colors.lightBlue.withOpacity(0.5) : Colors.transparent,
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 50),
              margin: EdgeInsets.only(
                  top: 5.0,
                  left: replied && countState.selectedChat == widget.id ? animatedPadding : widget.sender ? 5.0 : 100.0,
                  right: replied && countState.selectedChat == widget.id ? animatedPadding : widget.sender ? 100.0 : 5.0
              ),
              child: Bubble(
                alignment: widget.sender ? Alignment.topLeft : Alignment.topRight,
                padding: BubbleEdges.only(right: 10.0),
                color: widget.sender ? Color(0xff002366) : Colors.lightBlue,
                child: widget.replyingChat != null ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        widget.owner != 'You' && widget.owner != null ?
                            Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(widget.owner,
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 16.0
                                ),
                              ),
                            ) :
                            SizedBox(),
                        Container(
                          width: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.grey[300],
                          ),
                          child: ListTile(
                            title: Text(widget.replyOwner,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: widget.isReplyPicture ?
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(widget.replyingChat,
                                  width: 50.0,
                                  height: 50.0,
                                ),
                              ) :
                              Text(widget.replyingChat,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.0
                                ),
                              ),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, left: 5.0),
                          child: widget.isPicture ?
                          Image.asset(widget.text) :
                          Text(widget.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ) :
                    widget.owner != 'You' && widget.owner != null ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(widget.owner,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.lightBlue
                                ),
                              ),
                            ),
                            widget.isPicture ?
                            Image.asset(widget.text) :
                            Text(widget.text,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ) :
                        widget.isPicture ?
                        Image.asset(widget.text) :
                        Text(widget.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                nip: widget.sender ? BubbleNip.leftBottom : BubbleNip.rightBottom,
                elevation: 5.0,
              ),
            ),
            Positioned(
              left: widget.sender ? 1.0 : null,
              right: widget.sender ? null : 1.0,
              child: GestureDetector(
                onTap: (){
                  countState.setChat(null);
                  setState(() => replied = false);
                },
                child: Opacity(
                  opacity: replied && countState.selectedChat == widget.id ? 1.0 : 0.0,
                  child: Container(
                    margin: EdgeInsets.only(left: widget.sender ? 10.0 : 0.0, right: widget.sender ? 0.0 : 10.0, top: 5.0),
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Icon(Icons.close,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}