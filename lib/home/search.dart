import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../transitions/slide_left_route.dart';
import 'profile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  Future<List<SingleProfile>> search(String value) async{
    await Future.delayed(Duration(seconds: 2));
    var queryResultSet = [];
    var tempSearchStore = [];

    if (value.length == 0){
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length > 0){
      await searchByKey(value).then((QuerySnapshot docs){
        for (int i = 0; i < docs.documents.length; i++){
          setState(() {
            queryResultSet.add(docs.documents[i].data);
          });
        }
      });

      tempSearchStore = [];
      queryResultSet.forEach((element){
        if (element['name'].startsWith(capitalizedValue) || element['username'].startsWith(capitalizedValue)){
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

    if (tempSearchStore.length == 0) return [];

    return List.generate(tempSearchStore.length, (int index){
      return SingleProfile(
        tempSearchStore[index]['profilePicture'],
        tempSearchStore[index]['username'],
        tempSearchStore[index]['id'],
        tempSearchStore[index]['name'],
        tempSearchStore[index]['bio'],
        tempSearchStore[index]['followers'],
        tempSearchStore[index]['following'],
      );
    });
  }

  searchByKey(String field){
    return Firestore.instance.collection('users').where('searchKey', arrayContains: field.substring(0, 1).toUpperCase()).getDocuments();
  }

  Widget singleProfile(SingleProfile profile){
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: CachedNetworkImageProvider(profile.pUrl),
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
            onError: (error){
              return Text(error.toString());
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
  String uName, pUrl, name,  bio, index;
  int  followers, following;

  SingleProfile(
    this.pUrl,
    this.uName,
    this.index,
    this.name,
    this.bio,
    this.followers,
    this.following
  );
}