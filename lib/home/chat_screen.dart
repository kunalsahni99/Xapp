import 'package:flutter/material.dart';

import '../utils/prefs.dart';

class ChatScreen extends StatefulWidget {
  final String uName, pUrl;

  ChatScreen({this.uName, this.pUrl});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff73aef5),
        leading: IconButton(
          icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.uName),
      ),

    );
  }
}
