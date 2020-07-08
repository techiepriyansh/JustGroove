import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:justgroove/midi_processor.dart';
import 'package:justgroove/midi_provider.dart';

import 'package:justgroove/my_colors.dart';


class Playground extends StatefulWidget {

  List<MidiStroke> strokes;

  @override
  Playground(this.strokes, {Key key}) : super(key: key);

  @override
  PlaygroundState createState() => PlaygroundState();
}

class PlaygroundState extends State<Playground> {
  bool isClicked = false;

  int counter = 0;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    counter = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          playStroke();
        },
        onTapUp: (details) {
          stopStroke();
        },
        onTapCancel: () {
          stopStroke();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                isClicked
                    ? MyColors.darkGradientStart
                    : MyColors.normalGradientStart,
                isClicked
                    ? MyColors.darkGradientStop
                    : MyColors.normalGradientStop,
              ],
            ),
          ),
          child: Center(
            child: Text(
              "🎸",
              style: TextStyle(
                fontSize: 150,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }


  void playStroke() {

    List<int> notesToPlay = widget.strokes[counter].notes;

    if(notesToPlay.length != 0) {
      for(int mNote in notesToPlay) {
        MidiProvider.playMidiNote(mNote);
      }
    }

    setState() {
      isClicked = true;
    }
  }

  void stopStroke() {

    List<int> notesToStop = widget.strokes[counter].notes;

    if(notesToStop.length != 0) {
      for(int mNote in notesToStop) {
        MidiProvider.stopMidiNote(mNote);
      }
    }

    int conterToSet = counter + 1;
    if (counterToSet >= widget.strokes.length) counterToSet = 0;

    setState() {
      isClicked = false;
      counter = counterToSet;
    }
  }
}
