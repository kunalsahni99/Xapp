import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Prefs with ChangeNotifier{
  List<String> selected = [];
  int length = 0;

  void addItem(String item){
    selected.add(item);
    length++;
    notifyListeners();
  }

  void removeItem(String item){
    selected.remove(item);
    length--;
    notifyListeners();
  }
}

class Count with ChangeNotifier{
  int checkCount = 0;
  List<Map<String, String>> selectedAcc = [];

  void setList(){
    selectedAcc = [];
    notifyListeners();
  }

  void addAcc(Map<String, String> acc){
    selectedAcc.add(acc);
    notifyListeners();
  }

  void removeAcc(Map<String, String> acc){
    selectedAcc.remove(acc);
    notifyListeners();
  }

  void setCount(int c){
    checkCount = c;
    notifyListeners();
  }

  void incCount(){
    checkCount++;
    notifyListeners();
  }

  void decCount(){
    checkCount--;
    notifyListeners();
  }
}

class Utils{
  List<String> items = [
    'Movies',
    'Music',
    'Games',
    'Sports',
    'Comedy & Memes',
    'Environment',
    'Food',
    'Religion',
    'Fitness',
    'Science & Technology',
    'Fashion',
    'Career',
    'General Knowledge',
    'Meditation & Yoga',
    'Hobbies',
    'Art',
    'Politics (World)',
    'Politics (Indian)',
    'Business ideas'
  ],
  durationItems = [
    '30 min',
    '1 hr',
    '2 hr',
    '6 hr',
    '12 hr',
    '1 d',
    '1 week',
    'Forever'
  ];

  bool retIOS() => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

  void bottomSheet(BuildContext context){
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
  }
}