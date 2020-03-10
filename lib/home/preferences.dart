import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:collection/collection.dart';

import 'package:provider/provider.dart';
import '../utils/prefs.dart';
import '../transitions/enter_exit_route.dart';
import 'mainpage.dart';

class Preferences extends StatefulWidget {
  final List<String> userPrefs;

  Preferences({this.userPrefs});

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  List<String> selected = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.userPrefs != null){
      setState(() => Provider.of<Prefs>(context, listen: false).selected = widget.userPrefs);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemState = Provider.of<Prefs>(context);

    return Stack(
      children: <Widget>[
        Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff73aef5),
                      Color(0xff61a4f1),
                      Color(0xff478de0),
                      Color(0xff398ae5)
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9]
                  )
                ),
              ),

              ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 10.0),
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text(widget.userPrefs == null ? 'What are your interests?' : 'Edit your preferences...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  LiveGrid.options(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 30.0),
                    physics: BouncingScrollPhysics(),
                    options: LiveOptions(
                      showItemInterval: Duration(milliseconds: 100),
                      showItemDuration: Duration(milliseconds: 250),
                      visibleFraction: 0.05,
                    ),
                    itemBuilder: (context, index, animation){
                      bool checked = false;
                      if (widget.userPrefs != null && widget.userPrefs.contains(Utils().items[index])){
                        checked = true;
                      }
                      return FadeTransition(
                        opacity: Tween<double>(
                            begin: 0,
                            end: 1
                        ).animate(animation),
                        child: SlideTransition(
                          position: Tween<Offset>(
                              begin: Offset(0, -0.1),
                              end: Offset.zero
                          ).animate(animation),
                          child: SingleCategory(title: Utils().items[index], isChecked: checked),
                        ),
                      );
                    },
                    itemCount: Utils().items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                  )
                ],
              )
            ],
          ),

          floatingActionButton: Visibility(
            visible: itemState.selected.length == 0 ? false : true,
            child: InkWell(
              onTap: (){
                Function eq = const ListEquality().equals;
                setState(() => selected = itemState.selected);
                if (selected.length < 4){
                  Fluttertoast.showToast(msg: 'Select atleast 4 categories');
                }
                else{
                  setState(() => loading = true);
                  Timer(
                    Duration(seconds: 2),
                    (){
                      setState(() => loading = false);
                      if (widget.userPrefs != null && eq(widget.userPrefs, selected)){
                        Navigator.pop(context);
                        //todo: update user prefs in database

                      }
                      else{
                        Navigator.pushReplacement(context, EnterExitRoute(
                            enterPage: MainPage(),
                            exitPage: Preferences()
                        ));
                      }
                    }
                  );
                }
              },
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: Color(0xff73aef5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 2),
                        blurRadius: 6.0
                    )
                  ]
                ),
                child: itemState.selected.length == 0 ?
                    Icon(Icons.arrow_forward, color: Colors.white, size: 25.0) :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.check, color: Colors.white, size: 35.0),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                          child: Text(itemState.selected.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0
                            ),
                          ),
                        )
                      ],
                    ),
              ),
            ),
          )
        ),

        Visibility(
          visible: loading,
          child: Center(
            child: Utils().retIOS() ?
              Material(
                color: Colors.white.withOpacity(0.9),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SpinKitCircle(
                        size: 40.0,
                        color: Colors.black54,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text('Saving your preferences...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff73aef5),
                              fontSize: 20.0
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ) :
              Material(
                color: Colors.white.withOpacity(0.9),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff73aef5)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text('Saving your preferences...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff73aef5),
                            fontSize: 20.0
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),
        )
      ],
    );
  }
}

class SingleCategory extends StatefulWidget {
  final String title;
  final bool isChecked;

  SingleCategory({this.title, this.isChecked});

  @override
  _SingleCategoryState createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {
  bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    final itemState = Provider.of<Prefs>(context);

    return InkWell(
      onTap: (){
        setState(() => isChecked = !isChecked);
        if (isChecked){
          itemState.addItem(widget.title);
        }
        else{
          itemState.removeItem(widget.title);
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 2),
                  blurRadius: 6.0
                )
              ]
            ),
            child: Text(widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff398ae5),
                fontSize: 18.0,
                fontWeight: FontWeight.w600
              ),
            ),
          ),

          Visibility(
            visible: isChecked,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.1),
              ),
              child: Icon(Icons.check, color: Colors.white, size: 100.0),
            ),
          )
        ],
      )
    );
  }
}
