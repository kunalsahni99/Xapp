import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

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
  ];
  bool retIOS() => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
}