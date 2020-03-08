import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:line_icons/line_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xapp/home/further_info.dart';

import '../utils/prefs.dart';
import '../transitions/slide_left_route.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String dropVal = Utils().items[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10.0,
        leading: IconButton(
          icon: Icon(LineIcons.close, color: Color(0xff73aef5), size: 30.0),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text('Create Post',
          style: TextStyle(
            color: Color(0xff73aef5),
            fontWeight: FontWeight.bold
          ),
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: (){
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
                        height: 5.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0),
                        child: Text('Select image using',
                          style: TextStyle(
                            fontSize: 22.0
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.cameraRetro, size: 30.0),
                        title: Text('Camera'),
                        onTap: (){
                          //todo: open camera

                        },
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.solidImages, size: 30.0),
                        title: Text('Gallery'),
                        onTap: (){
                          //todo: open gallery

                        },
                      ),
                    ],
                  ),
                )
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 2.0,
                borderType: BorderType.RRect,
                radius: Radius.circular(10.0),
                child: Center(child: Icon(FontAwesomeIcons.image, size: 40.0)),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30.0,
                  height: 1.0,
                  color: Colors.grey,
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text('OR',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20.0
                    ),
                  ),
                ),

                Container(
                  width: 30.0,
                  height: 1.0,
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text('Select a category',
              style: TextStyle(
                fontSize: 20.0
              ),
            ),
          ),

          //todo: Here, thumbnail of each category will be displayed
          //todo: ask Vipul to give it ASAP
          DropdownButton(
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
          
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: RaisedButton(
              padding: EdgeInsets.only(left: 60.0, right: 60.0, top: 10.0, bottom: 10.0),
              child: Text('Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              color: Color(0xff73aef5),
              onPressed: (){
                //todo: check if a pic is selected; if not then save the drop down value and take to next page
                Navigator.push(context, SlideLeftRoute(page: FurtherInfo()));
              },
            ),
          )
        ],
      ),
    );
  }
}
