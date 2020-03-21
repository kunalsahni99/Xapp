import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:circular_check_box/circular_check_box.dart'; //todo: install this package
import 'package:xapp/home/chat_screen.dart';
import 'package:xapp/home/group_settings.dart';
import 'package:xapp/transitions/slide_top_route.dart';

import '../utils/prefs.dart';

class FollowList extends StatefulWidget {
  @override
  _FollowListState createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {


  @override
  Widget build(BuildContext context) {
    var countState = Provider.of<Count>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white
      ),
      child: WillPopScope(
        onWillPop: (){
          countState.setCount(0);
          countState.setList();
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff73aef5),
            leading: IconButton(
              icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
              onPressed: (){
                Navigator.pop(context);
                countState.setCount(0);
                countState.setList();
              },
            ),
            title: Text('New message',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Chat',
                  style: TextStyle(
                    color: countState.checkCount > 0 ? Colors.white : Color(0xff73aef5),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: //todo: If no account has been selected, pass null here
                countState.checkCount > 0 ? (){
                  Navigator.pushReplacement(context, SlideTopRoute(page: countState.checkCount > 1 ? GrpSettings(
                    accounts: countState.selectedAcc,
                  ) : ChatScreen(uName: countState.selectedAcc[0]['uName'],
                    pUrl: countState.selectedAcc[0]['pUrl'],
                  )));
                } : null,
              )
            ],
          ),

          body: ListView(
            children: <Widget>[
              //todo: a search field for searching accounts
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0.0
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.0
                      ),
                    ),
                    filled: true,
                    hintText: 'Search',
                    prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.lightBlue, size: 20),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 20.0),
                child: Text('Suggested',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),

              //todo: change this list when text field value changes
              ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                //todo: list of all followers
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
        ),
      ),
    );
  }
}

class SingleAccount extends StatefulWidget {
  final String uName, name, picUrl;

  SingleAccount({this.name, this.uName, this.picUrl});

  @override
  _SingleAccountState createState() => _SingleAccountState();
}

class _SingleAccountState extends State<SingleAccount> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var countState = Provider.of<Count>(context);

    return GestureDetector(
      onTap: (){
        setState((){
          isChecked = !isChecked;
          if (isChecked){
            countState.incCount();
            countState.addAcc({
              'uName': widget.uName,
              'pUrl': widget.picUrl
            });
          }
          else{
            countState.decCount();
            countState.removeAcc({
              'uName': widget.uName,
              'pUrl': widget.picUrl
            });
          }
        });
      },
      child: ListTile(
        //todo: profile pic of account
        leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage(widget.picUrl),
        ),

        //todo: user name of account
        title: Text(widget.uName,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),

        //todo: name of the account
        subtitle: Text(widget.name,
          style: TextStyle(
            color: Colors.black45,
            fontSize: 15.0
          ),
        ),

        trailing: CircularCheckBox(
          value: isChecked,
          onChanged: (x){
            setState(() {
              isChecked = x;
              if (isChecked){
                countState.incCount();
                countState.addAcc({
                  'uName': widget.uName,
                  'pUrl': widget.picUrl
                });
              }
              else{
                countState.decCount();
                countState.removeAcc({
                  'uName': widget.uName,
                  'pUrl': widget.picUrl
                });
              }
            });
          },
          activeColor: Colors.lightBlue,
        ),
      ),
    );
  }
}