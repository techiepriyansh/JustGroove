class Fqs {
  static final Map<String, int> coreFQS = {
    'C': 0,
    'D': 2,
    'E': 4,
    'F': 5,
    'G': 7,
    'A': 9,
    'B': 11
  };

  static final Map<int, String> coreFQS_inverted = {
    0: 'C',
    2: 'D',
    4: 'E',
    5: 'F',
    7: 'G',
    9: 'A',
    11: 'B'
  };
  
  static final Set<int> permittedDiff = {0,2,4,5,7,9,11};

  static int getNoteIndex(String noteString) {
    var coreFreq = noteString.substring(0, 1);
    int octaveNumber;
    int blackKeyOffset = 0;

    var processedNoteString = noteString.substring(1);

    if (processedNoteString.contains("#")) {
      blackKeyOffset = 1;
      processedNoteString = processedNoteString.replaceAll("#", "");
    } else if (processedNoteString.contains("b")) {
      blackKeyOffset = -1;
      processedNoteString = processedNoteString.replaceAll("b", "");
    }

    octaveNumber = int.parse(processedNoteString);

    int index = 12 * (octaveNumber + 1) + coreFQS[coreFreq] + blackKeyOffset;
    return index;
  }
  
  static String getNoteFromIndex(int noteIndex) {
    int octaveNumber = (noteIndex/12).floor() - 1;
    int coreOffset = noteIndex % 12;
    if(!permittedDiff.contains(coreOffset))
    {
      coreOffset -= 1;
      return coreFQS_inverted[coreOffset] + octaveNumber.toString() + "#";
    }
    else{
      return coreFQS_inverted[coreOffset] + octaveNumber.toString();
    }
  }
  
}



class MusicalKey {
  final String rootNote;
  final String formula;
  int octaveLength;
  List<int> coreNotes = [];

  //pass the root note in letters and also pass the formula as string
  MusicalKey(this.rootNote, this.formula) {
    octaveLength = formula.length;
    var noteDiffs = ("0" + formula)
        .split("")
        .map((noteString) => int.parse(noteString))
        .toList();
    noteDiffs.removeLast();

    int sum = 0;
    for (int i = 0; i < noteDiffs.length; i++) {
      sum += noteDiffs[i];
      coreNotes.add(Fqs.getNoteIndex(rootNote) + sum);
    }

  }

  //degree should not be zero
  int getNoteAt(int degree) {
    int reqNote;
    if (degree > 0) {
      reqNote = 12 * ((degree - 1) / octaveLength).floor() + coreNotes[(degree - 1) % octaveLength];
    } else {
      reqNote = 12 * (degree / octaveLength).floor() + coreNotes[degree % octaveLength];
    }
    return reqNote;
  }

  static MusicalKey getKey(String keyRootNote, String keyType)
  {
    switch(keyType){
      case "Major": { return getMajor(keyRootNote); }
      break;

      case "Minor":  {return getMinor(keyRootNote); }
      break;

      case "Blues Major": { return getMajorBlues(keyRootNote); }
      break;

      case "Blues Minor": { return getMinorBlues(keyRootNote); }
      break;
    }
  }

  static MusicalKey getMajor(String majorKeyRootNote) {
    return MusicalKey(majorKeyRootNote, "2212221");
  }

  static MusicalKey getMinor(String minorKeyRootNote) {
    return MusicalKey(minorKeyRootNote, "2122122");
  }
  
  static MusicalKey getMinorBlues(String minorBluesRootNote) {
    return MusicalKey(minorBluesRootNote, "321132");
  }
  
  static MusicalKey getMajorBlues(String majorBluesRootNote) {
    return MusicalKey(majorBluesRootNote, "211323");
  }
}