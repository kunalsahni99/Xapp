import 'package:flutter/material.dart';

import '../utils/prefs.dart';

class UserAvatar extends StatelessWidget {
  final String name, pUrl;
  final int tag;

  UserAvatar({this.pUrl, this.name, this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Hero(
        tag: tag,
        child: Center(child: Image.asset(pUrl))
      ),
    );
  }
}