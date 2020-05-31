import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import 'prefs.dart';

class Preview extends StatefulWidget {
  final File image;

  Preview({
    Key key,
    this.image
  }) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  Widget tempWidget;

  @override
  void initState() {
    super.initState();
    tempWidget = Utils().loadingScreen();
    Timer(
      Duration(seconds: 1),
      (){
        setState(() => tempWidget = Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Image.file(widget.image),
          ),
        ));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    String url, name = path.basename(widget.image.path);
    bool isLoading = false;

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, null);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context, null);
            }
          ),
          elevation: 0.0,
          title: Text('Preview',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),

        body: Stack(
          children: [
            tempWidget,

            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.white.withOpacity(0.6),
                child: Utils().loadingScreen(),
              ),
            )
          ],
        ),

        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
          child: FloatingActionButton(
            onPressed: () async{
              setState(() => isLoading = true);
              //todo: add userID from SharedPreferences
              //todo: change security rules for Storage when authentication is integrated
              final StorageReference ref = FirebaseStorage.instance.ref().child('comments/0001/$name');
              StorageUploadTask task = ref.putFile(widget.image);

              await task.onComplete.then((taskSnapshot) async{
                url = await taskSnapshot.ref.getDownloadURL();
              });
              setState(() => isLoading = false);
              Navigator.pop(context, url);
            },
            child: Icon(FontAwesomeIcons.check, color: Colors.white),
            elevation: 5.0,
          ),
        ),
      ),
    );
  }
}