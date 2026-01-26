MEBacktrack {

	*backtrackChords { |vocalRange, nextChord, validChords, i|
		var voice = MEVoice.voiceNames[i];

		"backtrackChords".postln;

		if (i == MEVoice.voiceNumber) {
			if (MEChordRules.chordIsValid(nextChord)) {
				validChords.add(nextChord.copy.postln);
				^nil;
			}
		};

		vocalRange[voice].do { |n|
			nextChord[i] = n.copy;
			if (MEChordRules.checkVoiceSpacing(nextChord, i)) {
				MEBacktrack.backtrackChords(vocalRange, nextChord, validChords, i + 1);
			} {
				nextChord[i] = 0;
			};
		}

	}
}