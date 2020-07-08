import 'package:flutter/material.dart';

import 'package:justgroove/file_and_track_chooser_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Groove',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FileAndTrackChooserPage(),
    );
  }
}
