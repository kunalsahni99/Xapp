import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../utils/prefs.dart';
import '../utils/fade_in.dart';

class FurtherInfo extends StatefulWidget {
  final File image;

  FurtherInfo({this.image});

  @override
  _FurtherInfoState createState() => _FurtherInfoState();
}

class _FurtherInfoState extends State<FurtherInfo> {
  final GlobalKey<FormState> fKey = GlobalKey<FormState>();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  String dropVal = Utils().items[0];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff73aef5),
        elevation: 10.0,
        leading: IconButton(
          icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white, size: 30.0),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Give your post a...',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: <Widget>[
          FlatButton(
            color: Colors.transparent,
            child: Text('POST',
              style: TextStyle(
                color: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeIn(
                delay: 1.33,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0, top: 20.0, left: 30.0),
                  child: Text('Category',
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                ),
              ),

              FadeIn(
                delay: 1.66,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: DropdownButton(
                    value: dropVal,
                    icon: Icon(Icons.arrow_drop_down, size: 30.0, color: Colors.grey),
                    onChanged: (newVal){
                      setState(() => dropVal = newVal);
                    },
                    items: Utils().items.map<DropdownMenuItem<String>>((val){
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                  ),
                ),
              ),

              FadeIn(
                delay: 1.99,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        color: Colors.black
                      )
                    ),
                    maxLines: 3,
                    focusNode: focusNode1,
                    maxLength: 20,
                  ),
                ),
              ),

              FadeIn(
                delay: 2.2,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                        labelStyle: TextStyle(
                            color: Colors.black
                        )
                    ),
                    maxLines: 10,
                    maxLength: 1000,
                    focusNode: focusNode2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}