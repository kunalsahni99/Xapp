import 'package:flutter/cupertino.dart';
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
  bool retIOS() => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
}