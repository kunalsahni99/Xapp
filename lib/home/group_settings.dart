import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xapp/home/chat_screen.dart';
import 'package:xapp/transitions/slide_left_route.dart';

import 'follow_list.dart';
import '../utils/prefs.dart';

class GrpSettings extends StatefulWidget {
  final List<Map<String, String>> accounts;

  GrpSettings({this.accounts});

  @override
  _GrpSettingsState createState() => _GrpSettingsState();
}

class _GrpSettingsState extends State<GrpSettings> {
  final key = GlobalKey();
  String grpName, dropVal = Utils().durationItems[0];
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var countState = Provider.of<Count>(context);

    return WillPopScope(
      onWillPop: (){
        countState.setList();
        countState.setCount(0);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff73aef5),
          leading: IconButton(
            icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
            onPressed: (){
              Navigator.pop(context);
              countState.setList();
              countState.setCount(0);
            },
          ),
          title: Text('Group Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

        body: ListView(
          padding: EdgeInsets.only(left: 20.0),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width / 2.5,
              child: ListView.builder(
                itemCount: widget.accounts.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20.0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: AssetImage(widget.accounts[index]['pUrl']),
                              radius: 40.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text(widget.accounts[index]['uName']),
                            )
                          ],
                        ),

                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: GestureDetector(
                            onTap: (){
                              if (widget.accounts.length == 2){
                                Fluttertoast.showToast(msg: 'Atleast two partcipants should exist in a group');
                              }
                              else{
                                countState.decCount();
                                countState.removeAcc(widget.accounts[index]);
                              }
                            },
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: Center(
                                child: Icon(Icons.close,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 50.0),
              child: Divider(color: Colors.grey),
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Utils().bottomSheet(context);
                    },
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.photo_camera, color: Colors.black54),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    padding: EdgeInsets.only(left: 10.0, right: 40.0),
                    child: TextField(
                      controller: controller,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type group name here',
                        helperText: 'Give a group name and an optional group icon',
                        helperMaxLines: 2
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Select duration of group',
                        style: TextStyle(
                          fontSize: 18.0
                        ),
                      ),

                      Tooltip(
                        key: key,
                        preferBelow: false,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        showDuration: Duration(seconds: 2),
                        margin: EdgeInsets.only(left: 100.0, right: 50.0),
                        message: 'Duration will tell for much time this group will exist',
                        child: IconButton(
                          icon: Icon(FontAwesomeIcons.solidQuestionCircle, size: 18.0,),
                          onPressed: (){
                            final dynamic tooltip = key.currentState;
                            tooltip.ensureTooltipVisible();
                          },
                        ),
                      )
                    ],
                  ),

                  DropdownButton(
                    value: dropVal,
                    icon: Icon(Icons.arrow_drop_down, size: 30.0, color: Colors.grey),
                    onChanged: (newVal){
                      setState(() => dropVal = newVal);
                    },
                    items: Utils().durationItems.map<DropdownMenuItem<String>>((val){
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('Add more participants',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
            ),

            //todo: before displaying the list, check if the userID of the account isn't in the list of selected participants
            //todo: if it does, then don't show it here
            ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SingleAccount(name: 'Kunal Sahni', uName: 'IamKsahni', picUrl: 'images/pic.jpg'),
                SingleAccount(name: 'Vipul Dubey', uName: 'SarcasticKid', picUrl: 'images/pic1.jpg'),
                SingleAccount(name: 'Suraj Jha', uName: '@zero', picUrl: 'images/pic2.jpg'),
                SingleAccount(name: 'Kunal Sahni', uName: 'IamKsahni', picUrl: 'images/pic.jpg'),
                SingleAccount(name: 'Vipul Dubey', uName: 'SarcasticKid', picUrl: 'images/pic1.jpg'),
                SingleAccount(name: 'Suraj Jha', uName: '@zero', picUrl: 'images/pic2.jpg'),
                SingleAccount(name: 'Kunal Sahni', uName: 'IamKsahni', picUrl: 'images/pic.jpg'),
                SingleAccount(name: 'Vipul Dubey', uName: 'SarcasticKid', picUrl: 'images/pic1.jpg'),
                SingleAccount(name: 'Suraj Jha', uName: '@zero', picUrl: 'images/pic2.jpg'),
                SingleAccount(name: 'Kunal Sahni', uName: 'IamKsahni', picUrl: 'images/pic.jpg'),
                SingleAccount(name: 'Vipul Dubey', uName: 'SarcasticKid', picUrl: 'images/pic1.jpg'),
                SingleAccount(name: 'Suraj Jha', uName: '@zero', picUrl: 'images/pic2.jpg'),
                SingleAccount(name: 'Kunal Sahni', uName: 'IamKsahni', picUrl: 'images/pic.jpg'),
                SingleAccount(name: 'Vipul Dubey', uName: 'SarcasticKid', picUrl: 'images/pic1.jpg'),
                SingleAccount(name: 'Suraj Jha', uName: '@zero', picUrl: 'images/pic2.jpg'),
              ],
            )
          ],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          onPressed: (){
            if (controller.text.isNotEmpty){
              Navigator.pushReplacement(context, SlideLeftRoute(page: ChatScreen(
                uName: controller.text,
                pUrl: 'images/something.jpg',
                isGroup: true,
                participants: widget.accounts,
              )));
            }
            else{
              Fluttertoast.showToast(msg: 'Give a name to this group');
            }
          },
          child: Icon(FontAwesomeIcons.check, color: Colors.white),
        ),
      ),
    );
  }
}