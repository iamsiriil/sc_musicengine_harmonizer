MEChordRules : MERules {

	/**checkChordPosition { |nextChord|
		var bassNote = nextChord[0].number;

		//"checkChordPosition".postln;

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
			^bassNote == 7;
		}
		{ rules[\enforceExtendedInversion] } {
			^Set[9, 11, 13].includes(bassNote)
		};
	}*/


	/**checkVoiceSpacing { |nextChord, i|
		var cross, n;

		//"checkVoiceSpacing".postln;

		if ((i > 0)) {
			n = (nextChord[i].midi - nextChord[i - 1].midi);

			cross = if (rules[\enforceVoiceCrossProhibition]) {
				(n >= 0);
			} {
				(n >= -4);
			};

			^cross && (n <= 12)
		} {
			^true;
		}
	}*/


	*checkChordIsComplete { |nextChord|
		var chordInt = nextChord.collect { |c| c.degree }.asSet;
		var rangeInt = MESession.chordData.intervals.asSet;

		if (chordInt == rangeInt) {
			^true;
		};
		^false;
	}


	*chordIsValid { |nextChord|
		var result = true;

		//"chordIsValid".postln;

		/*if (rules[\enforceChordPosition]) {
			result = result && MEChordRules.checkChordPosition(nextChord);
		};*/
		result = result && MEChordRules.checkChordIsComplete(nextChord);

		^result;
	}

	*noteIsValid { |nextChord, menote, i|

		//"checkChordPosition_midi".postln;
		//"i: %".format(i).postln;

		if ((i == 0) && rules[\enforceChordPosition]) {
			case
			{ rules[\enforceRootPosition]      } { ^menote.number == 1 }
			{ rules[\enforceFirstInversion]    } { ^menote.number == 3 }
			{ rules[\enforceSecondInversion]   } { ^menote.number == 5 }
			{ rules[\enforceThirdInversion]    } { ^menote.number == 7 }
			{ rules[\enforceExtendedInversion] } { ^Set[9, 11, 13].includes(menote.number) }
		};
		if (i > 0) {
			^(nextChord[i].midi > nextChord[i - 1].midi) &&
			((nextChord[i].midi - nextChord[i - 1].midi).abs <= 12);
		};
		^true;
	}
}