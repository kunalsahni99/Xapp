import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/prefs.dart';

class FurtherInfo extends StatefulWidget {
  @override
  _FurtherInfoState createState() => _FurtherInfoState();
}

class _FurtherInfoState extends State<FurtherInfo> {
  final GlobalKey<FormState> fKey = GlobalKey<FormState>();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10.0,
        leading: IconButton(
          icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Color(0xff73aef5), size: 30.0),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Give your post a...'),
        actions: <Widget>[
          FlatButton(
            color: Colors.transparent,
            child: Text('POST',
              style: TextStyle(
                color: Color(0xff73aef5),
                fontSize: 20.0
              ),
            ),
            onPressed: (){
              //todo: create new post after validating fields

            },
          ),
        ],
      ),

      body: Form(
        key: fKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  maxLines: 3,
                  focusNode: focusNode1,
                  maxLength: 20,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 10,
                  maxLength: 1000,
                  focusNode: focusNode2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}