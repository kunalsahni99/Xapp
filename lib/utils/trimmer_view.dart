import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/trim_editor.dart';
import 'package:video_trimmer/video_viewer.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'prefs.dart';

class TrimmerView extends StatefulWidget {
  final Trimmer trimmer;
  final File video;

  TrimmerView({
    this.trimmer,
    this.video
  });

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  double startVal = 0.0, endVal = 0.0;
  bool isPlaying = false, progressVisibility = false, visible = true, isLoading = false;
  File vidPath;
  VideoPlayerController controller;
  String url;

  void saveVideo() async{
    setState((){
      progressVisibility = true;
      isLoading = true;
    });

    await widget.trimmer.saveTrimmedVideo(
      startValue: startVal,
      endValue: endVal
    ).then((value){
      setState((){
        progressVisibility = false;
        vidPath = File(value);

        controller = VideoPlayerController.file(vidPath)..initialize().then((value) async{
          if (controller.value.duration.inSeconds <= 30){
            //todo: compress the video before uploading
            File compVid = await Utils().compressVid(vidPath);
            final StorageReference ref = FirebaseStorage.instance.ref().child('comments/0001/${path.basename(compVid.path)}');
            StorageUploadTask task = ref.putFile(compVid);

            await task.onComplete.then((taskSnapshot) async{
              url = await taskSnapshot.ref.getDownloadURL();
            });

            setState(() => isLoading = false);
            if (url != null){
              Fluttertoast.showToast(msg: 'Video saved successfully');
              Navigator.pop(context, url);
            }
          }
          else{
            Fluttertoast.showToast(msg: 'Video should be less than 30 sec');
            setState(() => isLoading = false);
          }
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Edit Video',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),

          body: Builder(
            builder: (context) => Center(
              child: Container(
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: progressVisibility,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.lightBlue
                      ),
                    ),

                    Center(
                      child: TrimEditor(
                        viewerHeight: 50.0,
                        viewerWidth: MediaQuery.of(context).size.width,
                        onChangeStart: (val){
                          startVal = val;
                        },
                        onChangeEnd: (val){
                          endVal = val;
                        },
                        onChangePlaybackState: (val){
                          setState(() => isPlaying = val);
                        },
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() => visible = !visible);
                        },
                        child: Stack(
                          children: [
                            VideoViewer(),
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: visible ? 1.0 : 0.0,
                              child: Container(
                                color: Colors.black26,
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play, color: Colors.white),
                                    onPressed: () async{
                                      bool playBackState = await widget.trimmer.videPlaybackControl(
                                        startValue: startVal,
                                        endValue: endVal
                                      );
                                      setState((){
                                        isPlaying = playBackState;
                                        if (isPlaying){
                                          Timer(
                                            Duration(seconds: 2),
                                            (){
                                              visible = !visible;
                                            }
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ),
                              )
                            )
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: progressVisibility ? null :
            () => saveVideo(),
            backgroundColor: Colors.lightBlue,
            child: Icon(FontAwesomeIcons.check, color: Colors.white),
          ),
        ),

        Visibility(
          visible: isLoading,
          child: Container(
            color: Colors.white.withOpacity(0.7),
            child: Utils().loadingScreen(),
          ),
        )

      ],
    );
  }
}