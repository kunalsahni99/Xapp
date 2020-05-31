import 'dart:io';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../utils/preview.dart';
import 'trimmer_view.dart';


//todo: for keeping the count of preferences selected
class Prefs with ChangeNotifier {
  List<String> selected = [];
  int length = 0;

  void addItem(String item) {
    selected.add(item);
    length++;
    notifyListeners();
  }

  void removeItem(String item) {
    selected.remove(item);
    length--;
    notifyListeners();
  }
}

//todo: for keeping the count of no of accounts selected for chats
//todo: plus keeping the count of no of chat bubbles selected
class Count with ChangeNotifier {
  int checkCount = 0,
      chatCount = 0;
  List<Map<String, String>> selectedAcc = [];
  String selectedChat;

  void setChat(String id) {
    selectedChat = id;
    notifyListeners();
  }

  void setList() {
    selectedAcc = [];
    notifyListeners();
  }

  void addAcc(Map<String, String> acc) {
    selectedAcc.add(acc);
    notifyListeners();
  }

  void removeAcc(Map<String, String> acc) {
    selectedAcc.remove(acc);
    notifyListeners();
  }

  void setChatCount() {
    chatCount = 0;
    notifyListeners();
  }

  void incChatCount() {
    chatCount++;
    notifyListeners();
  }

  void decChatCount() {
    chatCount--;
    notifyListeners();
  }

  void setCount(int c) {
    checkCount = c;
    notifyListeners();
  }

  void incCount() {
    checkCount++;
    notifyListeners();
  }

  void decCount() {
    checkCount--;
    notifyListeners();
  }
}

class Utils {
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
  final flutterVidCompress = FlutterVideoCompress();

  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white,
      border: Border(
          top: BorderSide(width: 1.0, color: Colors.lightBlue)
      )
  );

  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color: Colors.grey, width: 0.0),
  ),

      enabledBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.white, width: 0.0),
      );

  Future<SharedPreferences> getPrefs() async =>
      await SharedPreferences.getInstance();

  bool retIOS() =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

  Widget loadingScreen() {
    return Center(
      child: SpinKitChasingDots(
        color: Colors.lightBlue,
        size: 50.0,
      ),
    );
  }

  Future<File> compressVid(File file) async {
    final info = await flutterVidCompress.compressVideo(
        file.path,
        quality: VideoQuality.HighestQuality
    );
    return info.file;
  }

  Future getUrl(BuildContext context, bool isCamera, bool isImage) async {
    var img;
    final Trimmer trimmer = Trimmer();
    if (isImage) {
      img = await ImagePicker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (img != null) {
        var url = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => Preview(image: img)
        ));
        return url;
      }
    }
    else {
      img = await ImagePicker.pickVideo(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (img != null) {
        await trimmer.loadVideo(videoFile: img);
        var url = Navigator.push(context, MaterialPageRoute(
            builder: (_) => TrimmerView(trimmer: trimmer, video: img)
        ));
        return url;
      }
    }
  }
}