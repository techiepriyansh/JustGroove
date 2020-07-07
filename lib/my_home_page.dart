import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:justgroove/file_and_track_chooser_page.dart';

import 'package:justgroove/my_colors.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                MyColors.normalGradientStart,
                MyColors.normalGradientStop,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      "JUST GROOVE",
                      style: TextStyle(
                        fontSize: 50,
                        color: MyColors.dark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FileAndTrackChooserPage()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: MyColors.dark,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            
                          ),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "From File",
                              style: TextStyle(
                                fontSize: 30,
                                color: MyColors.dark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}