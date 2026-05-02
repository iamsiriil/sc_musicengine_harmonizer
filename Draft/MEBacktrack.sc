MEBacktrack : MEChordRules {
	classvar <>counter = 0;

	/****************************************************************************************/

	*backtrackChords { |chordData, nextChord, validChords, i|
		var voice = MEVoice.voiceNames[i];

		counter = counter + 1;

		//"backtrackChords".postln;

		if (i == MEVoice.voiceNumber) {
			if (super.chordIsValid(nextChord, chordData)) {
				validChords.add(nextChord.copy);
			}
		};

		chordData[\range][voice].do { |n|

			nextChord[i] = n;

			if (super.noteIsValid(nextChord, n, chordData, i)) {
				this.backtrackChords(chordData, nextChord, validChords, i + 1);
			} {
				nextChord[i] = 0;
			};
		}
	}

	/****************************************************************************************/

	//*backtrackChord {}

	/****************************************************************************************/

	//*backtrackProgression {}
}