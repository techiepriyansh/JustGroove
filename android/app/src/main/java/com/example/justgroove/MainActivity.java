package com.example.justgroove;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import org.billthefarmer.mididriver.MidiDriver;
import org.billthefarmer.mididriver.MidiConstants;
import org.billthefarmer.mididriver.GeneralMidiConstants;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.mathbert.dev/midi";

  private MidiDriver midiDriver;

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);

    midiDriver = new MidiDriver();

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {

            if (call.method.equals("startMidi")) {
              int _instrument_number = call.argument("instrument_number");
              midiDriver.setOnMidiStartListener(new MidiDriver.OnMidiStartListener(){
                  @Override
                  public void onMidiStart() {
                      sendMidi(MidiConstants.PROGRAM_CHANGE,
                      _instrument_number);
                      result.success("Started");
                  }
              });
              midiDriver.start();
            } 
            else if (call.method.equals("stopMidi")) {
              if (midiDriver != null) {
                  midiDriver.stop();
                  result.success("Stopped");
              }               
            }
            else if (call.method.equals("changeInstrument")) {
              int _instrument_number = call.argument("instrument_number");
              sendMidi(MidiConstants.PROGRAM_CHANGE,
              _instrument_number);
              result.success("Changed");
            }
            else if (call.method.equals("playMidiNote")) {
                int _note = call.argument("note");
                int _velocity = call.argument("velocity");
                playMidiNote(_note, _velocity);
                result.success("Played note");
            }
            else if (call.method.equals("stopMidiNote")) {
                int _note = call.argument("note");
                stopMidiNote(_note);
                result.success("Stopped note");
            }              
            else {
              result.notImplemented();
            }
          }
        );
  }

  private void sendMidi(int m, int n){
      byte msg[] = new byte[2];

      msg[0] = (byte) m;
      msg[1] = (byte) n;

      midiDriver.write(msg);
  }

  private void sendMidi(int m, int n, int v) {
    byte msg[] = new byte[3];

    msg[0] = (byte) m;
    msg[1] = (byte) n;
    msg[2] = (byte) v;

    midiDriver.write(msg);
  }

  private void playMidiNote(int n, int v) {
      sendMidi(MidiConstants.NOTE_ON, n, v);
  }

  private void stopMidiNote(int n) {
      sendMidi(MidiConstants.NOTE_OFF, n, 0);
  }

}