MEChordRules : MERules {

	*checkChordPosition { |nextChord|
		var rules    = MERules.default;
		var bassNote = nextChord[0].number;

		"checkChordPosition";

		if (rules[\enforceChordPosition]) {

			case
			{ rules[\enforceRootPosition] } {
				^(bassNote == 1);
			}
			{ rules[\enforceFirstInversion] } {
				^bassNote == 3;
			}
			{ rules[\enforceSecondInversion] } {
				^bassNote == 5;
			}
			{ rules[\enforceThirdInversion] } {
				^bassNote == 14;
			}
			{ rules[\enforceExtendedInversion] } {
				^Set[9, 11, 13].includes(bassNote)
			};
		} {
			^true;
		};
	}

	*checkVoiceSpacing { |nextChord, i|
		var rules = super.default;
		var cross, n;

		"checkVoiceSpacing".postln;

		if ((i > 0)) {
			n = (nextChord[i].midi - nextChord[i - 1].midi);

			cross = if (rules[\enforceVoiceCrossProhibition]) {
				(n >= 0);
			} {
				(n <= -4);
			};

			switch(i)
			{ 1 } { ^cross && (n <= 12) }
			{ 2 } { ^cross && (n <= 12) }
			{ 3 } { ^cross && (n <= 12) }
		} {
			^true;
		}
	}

	*checkChordIsComplete { |nextChord|
		var chordInt = nextChord.collect { |c| c.degree }.asSet.postln;
		var rangeInt = MESession.chordData.intervals.asSet;

		if (chordInt == rangeInt) {
			^true;
		};
		^false;
	}

	*chordIsValid { |nextChord|
		var result = true;

		"chordIsValid".postln;

		result = result && MEChordRules.checkChordPosition(nextChord);
		result = result && MEChordRules.checkChordIsComplete(nextChord);
		^result.postln;
	}
}