MEBacktrack : MEChordRules {
	classvar <>counter = 0;


	*backtrackChords { |vocalRange, nextChord, validChords, i|
		var voice = MEVoice.voiceNames[i];

		counter = counter + 1;

		//"backtrackChords".postln;

		if (i == MEVoice.voiceNumber) {
			if (super.chordIsValid(nextChord)) {
				validChords.add(nextChord.copy);
				^nil;
			}
		};

		vocalRange[voice].do { |n|

			nextChord[i] = n;

			if (super.noteIsValid(nextChord, n, i)) {
				this.backtrackChords(vocalRange, nextChord, validChords, i + 1);
			} {
				nextChord[i] = 0;
			};
		}

	}
}