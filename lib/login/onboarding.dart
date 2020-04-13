import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:xapp/login/login.dart';
import 'package:xapp/transitions/enter_exit_route.dart';

class PageData {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class OnBoarding extends StatelessWidget {
  final List<PageData> pages = [
    PageData(
      title: 'Choose your\ninterests',
      icon: Icons.format_size,
      textColor: Colors.white,
      bgColor: Color(0xffFDBFDD)
    ),
    PageData(
      icon: Icons.hdr_weak,
      title: "A text to be\nplaced here",
      bgColor: Color(0xFFFFFFFF),
    ),
    PageData(
      icon: Icons.bubble_chart,
      title: "A text to be\nplaced here",
      bgColor: Color(0xFF0043D0),
      textColor: Colors.white,
    ),
  ];

  List<Color> get colors => pages.map((p) => p.bgColor).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConcentricPageView(
            colors: colors,
            opacityFactor: 1.0,
            scaleFactor: 0.0,
            radius: 500,
            curve: Curves.ease,
            duration: Duration(milliseconds: 1500),
            verticalPosition: 0.7,
            //itemCount: pages.length,
            itemBuilder: (index, value){
              PageData page = pages[index % pages.length];

              return Container(
                child: Theme(
                  data: ThemeData(
                    textTheme: TextTheme(
                      subtitle1: TextStyle(
                        color: page.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: constraints.maxHeight > 720.0 ? 36.0 : 30.0,
                      ),
                    ),
                  ),
                  child: PageCard(page: page, index: pages.indexOf(page)),
                ),
              );
            },
          );
        }
      ),
    );
  }
}

class PageCard extends StatelessWidget {
  final PageData page;
  final int index;

  PageCard({
    this.page,
    this.index,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              height: constraints.maxHeight,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 190.0,
                    height: 190.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60.0)),
                      color: page.bgColor
                          .withGreen(page.bgColor.green + 20)
                          .withRed(page.bgColor.red - 100)
                          .withAlpha(90),
                    ),
                    margin: EdgeInsets.only(top: constraints.maxHeight > 720 ? 140.0 : 100.0),
                    //todo: replace this stack with image
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Positioned.fill(
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: Icon(page.icon, size: 190.0, color: page.bgColor
                                .withBlue(page.bgColor.blue - 10)
                                .withGreen(220),
                            ),
                          ),
                          right: -5,
                          bottom: -5,
                        ),

                        Positioned.fill(
                          child: RotatedBox(
                            quarterTurns: 5,
                            child: Icon(
                              page.icon,
                              size: 190.0,
                              color: page.bgColor.withGreen(66).withRed(77),
                            ),
                          ),
                        ),

                        Icon(
                          page.icon,
                          size: 170.0,
                          color: page.bgColor.withRed(111).withGreen(220),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: constraints.maxHeight > 720.0 ? 80.0 : 60.0),

                  Text(page.title,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),

            Positioned(
              top: 30.0,
              right: 10.0,
              child: Opacity(
                opacity: index == 2 ? 1.0 : 0.0,
                child: InkWell(
                  onTap: index == 2 ?
                    () => Navigator.pushReplacement(context, EnterExitRoute(enterPage: Login(), exitPage: OnBoarding())) : null,
                  child: Container(
                    width: 100.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: page.bgColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Text('Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        Icon(Icons.arrow_forward_ios,
                          size: 10.0,
                          color: Colors.white,
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
    );
  }
}
