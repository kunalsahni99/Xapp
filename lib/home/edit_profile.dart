import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> fKey = GlobalKey<FormState>();
  String name = "", uName = "", bio = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LineIcons.close, color: Color(0xff73aef5), size: 30.0),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 10.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(LineIcons.check, color: Color(0xff73aef5), size: 30.0),
            onPressed: (){
              //todo: save the form and edit the profile fields

            },
          )
        ],
        title: Text('Edit Profile',
          style: TextStyle(
            color: Color(0xff73aef5),
            fontWeight: FontWeight.bold
          ),
        ),
      ),

      body: Form(
        key: fKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  onSaved: (value) => name = value,
                  validator: (value) => value == null ? "Please fill this field" : null,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  onSaved: (value) => uName = value,
                  validator: (value) => value == null ? "Please fill this field" : null
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Bio',
                  ),
                  maxLines: 4,
                  maxLength: 40,
                  onSaved: (value) => bio = value,
                  validator: (value) => value == null ? "Please fill this field" : null
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
