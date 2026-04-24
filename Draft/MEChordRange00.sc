
MEChordRange00 : MENoteRange {
	var chordData;
	var chordRange;
	var index;
	var out;

	*new { |symbol, prevChord, ruleDict, voiceNum = 4|
		^super.new.init(symbol, prevChord, ruleDict, voiceNum);
	}

	init { |newS, newC, newV|

/* 1. Generate MENoteRange
      - If range in MESession, copy, else generate MENoteRange */

/* 2. Set voice number in MEVoice */

/* 3. Set rule profile
      - If ruleDict.isNil, set default from MERules, else set ruleDict */

/* 4. Save data into data dict:
      - symbol  (as Symbol)
      - degrees (array of MEIntervals) */

/* 5. Get valid notes
      - get vocal range
      - if prevChord.notNil, sort by proximity */

/* 6. Get chords */

		^this;

	}

//*getChordVocalRange
}
