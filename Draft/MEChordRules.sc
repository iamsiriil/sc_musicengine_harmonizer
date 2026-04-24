MEChordRules : MERules {

	*checkChordIsComplete { |nextChord, data|
		var chordInt = nextChord.collect { |c| c.degree }.asSet;
		var rangeInt = data[\degrees].asSet;

		//"checkChordIsComplete".postln;

		^(chordInt == rangeInt);
	}

	/****************************************************************************************/


	*chordIsValid { |nextChord, data|
		var result = true;

		//"chordIsValid".postln;

		^MEChordRules.checkChordIsComplete(nextChord, data);
	}

	/****************************************************************************************/

	*checkUnisons { |nextChord, menote|
		var notes = nextChord.select { |n| n.isKindOf(MENote) };

		//"checkUnisons".postln;

		^notes.count { |n| n.name == menote.name } <= 2;
	}

	/****************************************************************************************/

	*checkDuplicateDegrees { |nextChord, menote, data|
		var notes = nextChord.select { |n| n.isKindOf(MENote) };
		var degreeNum = data[\degrees].size;

		//"checkDuplicateDegrees".postln;

		if (degreeNum == 3) {
			^notes.count { |n| n.degree == menote.degree } <= 3;
		} {
			^notes.count { |n| n.degree == menote.degree } <= 2;
		};
	}

	/****************************************************************************************/

	*checkVoiceSpacing { |nextChord, data, i|
		var degreesNum = data[\degrees].size;
		var voiceNum   = MEVoice.voiceNumber;

		//"checkVoiceSpacing".postln;

		if (degreesNum == voiceNum) {
			^(nextChord[i].midi > nextChord[i - 1].midi) &&
			((nextChord[i].midi - nextChord[i - 1].midi).abs <= 12);
		} {
			^(nextChord[i].midi >= nextChord[i - 1].midi) &&
			((nextChord[i].midi - nextChord[i - 1].midi).abs <= 12);
		};
	}

	/****************************************************************************************/

	*checkRepeatedDegrees { |nextChord, menote, data|
		var degreesArr = nextChord.select { |n| n.isKindOf(MENote) }.collect{ |n| n.degree };
		var degreesSet = degreesArr.asSet;

		//"checkRepeatedDegrees".postln;

		^(degreesArr.size == degreesSet.size);
	}

	/****************************************************************************************/

	*noteIsValid { |nextChord, menote, data, i|
		var degreesNum = data[\degrees].size;
		var voiceNum   = MEVoice.voiceNumber;

		//"noteIsValid".postln;

		case
		{ (i == 0) && rules[\enforceChordPosition] } {
			case
			{ rules[\enforceRootPosition]      } { ^menote.number(true) == 1 }
			{ rules[\enforceFirstInversion]    } { ^menote.number(true) == 3 }
			{ rules[\enforceSecondInversion]   } { ^menote.number(true) == 5 }
			{ rules[\enforceThirdInversion]    } { ^menote.number(true) == 7 }
			{ rules[\enforceExtendedInversion] } { ^Set[9, 11, 13].includes(menote.number(true)) }
		}
		{ (i > 0) && (degreesNum == voiceNum) } {
			^(this.checkVoiceSpacing(nextChord, data, i) &&
			this.checkRepeatedDegrees(nextChord, menote, data));
		}
		{ (i > 0) && (degreesNum < voiceNum) } {
			^(this.checkVoiceSpacing(nextChord, data, i) &&
			this.checkUnisons(nextChord, menote)         &&
			this.checkDuplicateDegrees(nextChord, menote, data));
		};
		^true;
	}
}