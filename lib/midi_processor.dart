import 'package:dart_midi/dart_midi.dart';
import 'dart:io';


class MidiProcessor {
  final String filePath;
  MidiFile parsedMidi;
  
  MidiProcessor(this.filePath) 
  {
    var file = File(filePath);
    var parser = MidiParser();

    parsedMidi = parser.parseMidiFromFile(file);
  }

  int getMicrosecondsPerBeat()
  {
    int mpb = 500000;
    for(List<MidiEvent> track in parsedMidi.tracks)
    {
      for(MidiEvent event in track)
      {
        if(event.type == "setTempo")
        {
          mpb = (event as SetTempoEvent).microsecondsPerBeat;
          break;
        }
      }
    }

    return mpb;
  }

  double getTempo()
  {
    int mpb = getMicrosecondsPerBeat();
    return 60000000/mpb ;
  }

  List<MidiStroke> getStrokes(int trackIndex, {int algorithmIndex})
  {
    if(algorithmIndex == null) algorithmIndex = AlgorithmIndices.KEEP_EXTENDED_NOTES;
    int tpb = parsedMidi.header.ticksPerBeat;
    int mpb = getMicrosecondsPerBeat(); 

    List<MidiEvent> track = parsedMidi.tracks[trackIndex];

    double cumMillis = 0;
    Map<double, Map<String,List<int>>> myTrack = <double, Map<String,List<int>>>{};

    for(int i = 0; i < track.length; i++)
    {
      MidiEvent event = track[i];

      switch(event.type)
      {

        case "noteOn" :
        {
          NoteOnEvent mNoteOnEvent = event as NoteOnEvent;
          int _note = mNoteOnEvent.noteNumber;
          cumMillis += mNoteOnEvent.deltaTime * mpb / (1000 * tpb);
          cumMillis = num.parse(cumMillis.toStringAsFixed(2)); 

          if (myTrack[cumMillis] != null) 
          {
            if(myTrack[cumMillis]["noteOn"] != null) myTrack[cumMillis]["noteOn"].add(_note);
            else myTrack[cumMillis]["noteOn"] = <int>[_note];          
          }
          else myTrack[cumMillis] = {"noteOn" : <int>[_note]};

        }
        break;


        case "noteOff" : 
        {
          NoteOffEvent mNoteOffEvent = event as NoteOffEvent;
          int _note = mNoteOffEvent.noteNumber;
          cumMillis += mNoteOffEvent.deltaTime * mpb / (1000 * tpb);
          cumMillis = num.parse(cumMillis.toStringAsFixed(2));

          if (myTrack[cumMillis] != null) 
          {
            if(myTrack[cumMillis]["noteOff"] != null) myTrack[cumMillis]["noteOff"].add(_note);
            else myTrack[cumMillis]["noteOff"] = <int>[_note];          
          }
          else myTrack[cumMillis] = {"noteOff" : <int>[_note]};

        }
        break;
        
      }
        
    }

    double prevTimestamp  = myTrack.keys.toList()[0];

    Map<String,List<int>> prev = <String, List<int>>{};
    prev["noteOn"] = [];
    prev["noteOn"].addAll(myTrack[prevTimestamp]["noteOn"]);

    List<MidiStroke> strokes = [];

    for(int i = 1; i < myTrack.keys.length; i++)
    {
      double currTimestamp = myTrack.keys.toList()[i];
      var curr = myTrack[currTimestamp];

      double duration = (currTimestamp - prevTimestamp);
      duration = num.parse(duration.toStringAsFixed(2));

      if (curr["noteOff"] != null) 
      {
        List<int> notesToAdd = [];
        notesToAdd.addAll(prev["noteOn"]);
        strokes.add(MidiStroke(notesToAdd,duration));
        if (algorithmIndex == AlgorithmIndices.KEEP_EXTENDED_NOTES)
          prev["noteOn"].removeWhere((el) => curr["noteOff"].contains(el));
        else if(algorithmIndex == AlgorithmIndices.CUT_EXTENDED_NOTES)
          prev["noteOn"].removeWhere((el) => curr["noteOff"].contains(el) || prev["noteOn"].contains(el)); 
      }
      else
      {
        List<int> notesToAdd = [];
        notesToAdd.addAll(prev["noteOn"]);
        strokes.add(MidiStroke(notesToAdd,duration));

      }

      if(curr["noteOn"] != null) prev["noteOn"].addAll(curr["noteOn"]);

      prevTimestamp = currTimestamp;
      
    }


    return strokes;


  }


  List<String> getTrackNames() 
  {
    List<String> trackNames = [];
    for(int i = 0; i < parsedMidi.tracks.length; i++)
    {
      trackNames.add("Untitled MIDI Track $i");
    }


    for(int i = 0; i < parsedMidi.tracks.length; i++)
    {
      List<MidiEvent> track = parsedMidi.tracks[i];
      for(MidiEvent event in track)
      {
        if(event.type == "trackName")
        {
          trackNames[i] = (event as TrackNameEvent).text;
          break;
        }
      }
    }

    return trackNames;


  }

}

class MidiStroke{
  List<int> notes; //midi_numbers of notes
  double duration; //in milliseconds

  MidiStroke(this.notes, this.duration);

  @override
  String toString() => "${notes.toString()} : $duration";
}

class AlgorithmIndices{
  static final int KEEP_EXTENDED_NOTES = 0;
  static final int CUT_EXTENDED_NOTES = 1;
}
