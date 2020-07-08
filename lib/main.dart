import 'package:flutter/material.dart';

import 'package:justgroove/my_home_page.dart';
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








class FileAndTrackChooserPage extends StatefulWidget{
  
  @override
  _FileAndTrackChooserPageState createState() => _FileAndTrackChooserPageState();
}

class _FileAndTrackChooserPageState extends State<FileAndTrackChooserPage>{
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        
      ),
    );
  }
}