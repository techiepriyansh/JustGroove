import 'dart:async';
import 'package:flutter/services.dart';

import 'package:justgroove/midi_instruments.dart';

class MidiProvider{
  static const MethodChannel _channel = MethodChannel("samples.mathbert.dev/midi");

  static Future<void> startMidi({String instrument_name = "Acoustic Grand Piano"}) async {
    final Map<dynamic, dynamic> mapData = <dynamic, dynamic>{};

    int instrument_number = MidiInstruments.instruments[instrument_name];
    mapData["instrument_number"] = instrument_number;
    await _channel.invokeMethod("startMidi", mapData);
  }

  static Future<void> stopMidi() async {
    final Map<dynamic, dynamic> mapData = <dynamic, dynamic>{};
    await _channel.invokeMethod("stopMidi");
  }

  static Future<void> changeInstrument(String instrument_name) async {
    final Map<dynamic, dynamic> mapData = <dynamic, dynamic>{};
    mapData["instrument_number"] = MidiInstruments.instruments[instrument_name];
    await _channel.invokeMethod("changeInstrument", mapData);
  }
 
  static Future<void> playMidiNote(int note, {int velocity = 127}) async {
    final Map<dynamic, dynamic> mapData = <dynamic, dynamic>{};
    mapData["note"] = note;
    mapData["velocity"] = velocity;
    await _channel.invokeMethod("playMidiNote", mapData);
  }

  static Future<void> stopMidiNote(int note) async {
    final Map<dynamic, dynamic> mapData = <dynamic, dynamic>{};
    mapData["note"] = note;
    await _channel.invokeMethod("stopMidiNote", mapData);
  }
}
