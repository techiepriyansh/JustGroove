import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dart_midi/dart_midi.dart';

import 'dart:async';
import 'dart:io';

import 'package:justgroove/my_containers.dart';
import 'package:justgroove/midi_processor.dart';
import 'package:justgroove/midi_provider.dart';

import 'package:justgroove/my_colors.dart';

class FileAndTrackChooserPage extends StatefulWidget {
  @override
  _FileAndTrackChooserPageState createState() =>
      _FileAndTrackChooserPageState();
}

class _FileAndTrackChooserPageState extends State<FileAndTrackChooserPage> {

  File midiFile;
  String fileStatus;

  List<TrackNameAndIndex> trackNamesAndIndices = [];
  MidiProcessor mp;

  bool musicInProgress = false;
  int selectedTrackIndex;
  StreamSubscription subscription;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    MidiProvider.startMidi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (midiFile == null)
      fileStatus = "Choose a file";
    else {
      fileStatus = midiFile.path.split("/").last.split(".").first;
    }


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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: MyBorderedTextContainer(
                          text: fileStatus,
                          textColor: MyColors.dark,
                          textSize: 20,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: MyBorderedContainer(
                          child: IconButton(
                            onPressed: () => startFileSelection(),
                            icon: Icon(Icons.folder_open),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: ListView(
                    children: trackNamesAndIndices.map((el) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: MyColors.dark,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child: Text(
                                      el.trackName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: MyColors.dark,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: MyColors.dark,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: IconButton(
                                    icon: Icon(Icons.headset),
                                    color: (musicInProgress && selectedTrackIndex == el.trackIndex) ? MyColors.light : MyColors.dark,
                                    onPressed: () {
                                      //Play if the music is not playing or if it is playing but the track is different
                                      bool toPlayThis = (musicInProgress && selectedTrackIndex != el.trackIndex) || (!musicInProgress) ;
                                      if(toPlay) {
                                        selectedTrackIndex = el.trackIndex;
                                        startPlayingMusic();
                                      }
                                      else stopPlayingMusic();

                                      setState(() {
                                        musicInProgress = toPlay;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: MyColors.dark,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: IconButton(
                                    icon: Icon(Icons.play_arrow),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startFileSelection() async {
    File chosenFile = await FilePicker.getFile();
      
    setState(() {
      midiFile = chosenFile;
      mp = MidiProcessor(chosenFile.path);

      List<String> allTrackNames = mp.getTrackNames();

      trackNamesAndIndices = [];
      for(int i = 0; i < allTrackNames.length; i++ ){
        String currTrackName = allTrackNames[i];
        if(!(currTrackName.startsWith("Untitled")))
          trackNamesAndIndices.add(TrackNameAndIndex(currTrackName, i));
      }

    });
  }

  void startPlayingMusic() {

    subscription?.cancel();

    subscription = midiNotesSequencer().listen((MidiInfoForPlaying info) {

      switch (info.message) {
        case "Play Note": {
          if(info.notes.length != 0) {
            for(int mNote in info.notes) {
              MidiProvider.playMidiNote(mNote);
            }
          }      
        }
        break;

        case "Stop Note": {
          if(info.notes.length != 0) {
            for(int mNote in info.notes) {
              MidiProvider.stopMidiNote(mNote);
            }
          }
        }
        break;

        case "Stop Playing": {
          setState(() {
            musicInProgress = false;
          });
        }
      }
      break;
    });
    
  }

  void stopPlayingMusic() {
    subscription?.cancel();
  }

  Stream<MidiInfoForPlaying> midiNotesSequencer() async* {

    List<MidiStroke> midiStrokes = mp.getStrokes(selectedTrackIndex);

    for(MidiStroke stroke in midiStrokes){
      
      yield MidiInfoForPlaying("Play Note", stroke.notes);

      await Future.delayed(Duration(milliseconds: stroke.duration.round()), () => "Played!");

      yield MidiInfoForPlaying("Stop Note", stroke.notes);

    }

    yield MidiInfoForPlaying("Stop Playing", []);
  }

}


class MidiInfoForPlaying {
  String message;
  List<int> notes;
  MidiInfoForPlaying(this.message, this.notes);
}

class TrackNameAndIndex {
  String trackName;
  int trackIndex;

  TrackNameAndIndex(this.trackName, this.trackIndex);
}