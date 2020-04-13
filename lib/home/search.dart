import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flappy_search_bar/search_bar_style.dart';

import '../transitions/slide_left_route.dart';
import 'profile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<DocumentSnapshot> items = List<DocumentSnapshot>();
  DateTime eDate;

  //todo: uncomment this
  Future<List<SingleProfile>> search(String value) async{
//    await Future.delayed(Duration(seconds: 2));
//    var queryResultSet = [];
//    var tempSearchStore = [];
//
//    if (value.length == 0){
//      setState(() {
//        queryResultSet = [];
//        tempSearchStore = [];
//      });
//    }
//
//    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
//
//    if (queryResultSet.length == 0 && value.length > 0){
//      await searchByKey(value).then((QuerySnapshot docs){
//        for (int i = 0; i < docs.documents.length; i++){
//          setState(() {
//            queryResultSet.add(docs.documents[i].data);
//          });
//        }
//      });
//
//      tempSearchStore = [];
//      queryResultSet.forEach((element){
//
//      });
//    }
//
//    if (tempSearchStore.length == 0) return [];
//
//    return List.generate(tempSearchStore.length, (int index){
//      return Event(
//          tempSearchStore[index]['Ename'],
//          tempSearchStore[index]['Url1'],
//          tempSearchStore[index]['Url2'],
//          tempSearchStore[index]['Url3'],
//          tempSearchStore[index]['Url4'],
//          tempSearchStore[index]['Edesc'],
//          tempSearchStore[index]['orgn'],
//          tempSearchStore[index]['venue'],
//          tempSearchStore[index]['Edate'],
//          tempSearchStore[index]['eventID'],
//          tempSearchStore[index]['igLink'],
//          tempSearchStore[index]['fbLink']
//      );
//    });
  }

  searchByKey(String field){
    return Firestore.instance.collection('events').where('searchKey', isEqualTo: field.substring(0, 1).toUpperCase()).getDocuments();
  }

  Widget singleProfile(SingleProfile profile){
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: AssetImage(profile.pUrl),
      ),
      title: Text(profile.uName,
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
      subtitle: Text(profile.name,
        style: TextStyle(
            color: Colors.black45,
            fontSize: 13.0
        ),
      ),
      onTap: (){
        Navigator.push(context, SlideLeftRoute(page: Profile(
          pUrl: profile.pUrl,
          uName: profile.uName,
          name: profile.name,
          bio: profile.bio,
          followers: profile.followers,
          following: profile.following,
          isViewedProfile: true,
        )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SearchBar(
            onSearch: search,
            //todo: list of suggestions of SingleProfiles 
            suggestions: [
              SingleProfile(
                pUrl: 'images/pic.jpg',
                uName: 'IamKSahni',
                name: 'Kunal Sahni',
                followers: '200',
                following: '4',
                index: '0',
                bio: "Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content."
              ),
              SingleProfile(
                  pUrl: 'images/pic1.jpg',
                  uName: 'SarcasticKid',
                  name: 'Vipul Dubey',
                  followers: '200',
                  following: '4',
                  index: '1',
                  bio: "Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content."
              ),
              SingleProfile(
                  pUrl: 'images/pic2.jpg',
                  uName: '@zero',
                  name: 'Suraj Jha',
                  followers: '200',
                  following: '4',
                  index: '2',
                  bio: "Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content."
              ),
              SingleProfile(
                  pUrl: 'images/pic.jpg',
                  uName: 'IamKSahni',
                  name: 'Kunal Sahni',
                  followers: '200',
                  following: '4',
                  index: '3',
                  bio: "Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content."
              ),
              SingleProfile(
                  pUrl: 'images/pic2.jpg',
                  uName: '@zero',
                  name: 'Suraj Jha',
                  followers: '200',
                  following: '4',
                  index: '4',
                  bio: "Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content."
              ),
            ],
            buildSuggestion: (SingleProfile profile, int index){
              return singleProfile(profile);
            },
            onItemFound: (SingleProfile profile, int index){
              return singleProfile(profile);
            },
            shrinkWrap: true,
            searchBarStyle: SearchBarStyle(
                borderRadius: BorderRadius.circular(40.0)
            ),
            icon: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(Icons.search),
            ),
            hintText: 'Search',
            iconActiveColor: Colors.lightBlue,
            placeHolder: Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text('🧐',
                      style: TextStyle(
                        fontSize: 100.0
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text('Find people to express yourself...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 25.0
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            emptyWidget: Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.outlined_flag, size: 100.0, color: Colors.black54),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text('No results for your search',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text('Try using different keywords',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20.0
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            loader: Center(
              child: SpinKitCircle(
                color: Colors.black54,
                size: 50.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SingleProfile{
  String uName, pUrl, name, followers, following,  bio, index;

  SingleProfile({
    this.pUrl,
    this.uName,
    this.index,
    this.name,
    this.bio,
    this.followers,
    this.following
  });
}