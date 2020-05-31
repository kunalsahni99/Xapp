import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/valley_quad_curve.dart';
import 'prefs.dart';

class ShowMedia extends StatefulWidget {
  final String url;
  final bool isImage;

  ShowMedia({this.url, this.isImage});

  @override
  _ShowMediaState createState() => _ShowMediaState();
}

class _ShowMediaState extends State<ShowMedia> {
  VideoPlayerController controller;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    if (!widget.isImage) {
      controller = VideoPlayerController.network(widget.url)
        ..initialize().then((value) {
          setState(() {});
        });
      controller.setLooping(true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget.isImage){
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Utils().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isImage ? 'Image' : 'Video',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: widget.isImage
          ? Center(
              child: PhotoView(
                tightMode: true,
                minScale: 0.0,
                maxScale: 5.0,
                heroAttributes: PhotoViewHeroAttributes(
                  flightShuttleBuilder: (BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext) {
                    final Hero toHero = toHeroContext.widget;

                    return FadeTransition(
                      opacity: animation.drive(
                        Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(
                            curve: Interval(0.0, 1.0,
                                curve: ValleyQuadraticCurve()))),
                      ),
                      child: toHero.child,
                    );
                  },
                  tag: widget.url,
                ),
                imageProvider: CachedNetworkImageProvider(widget.url),
              ),
            )
          : GestureDetector(
              onTap: (){
                setState(() => visible = !visible);
              },
              child: Stack(
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: visible ? 1.0 : 0.0,
                      child: Container(
                        color: Colors.black26,
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                                controller.value.isPlaying
                                    ? FontAwesomeIcons.pause
                                    : FontAwesomeIcons.play,
                                color: Colors.white),
                            onPressed: () {
                              setState(() {
                                controller.value.isPlaying
                                    ? controller.pause()
                                    : controller.play();
                                if (controller.value.isPlaying) {
                                  Timer(Duration(seconds: 2), () {
                                    visible = !visible;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
          ),
    );
  }
}
