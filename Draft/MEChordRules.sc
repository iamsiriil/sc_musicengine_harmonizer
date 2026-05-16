MEChordRules : MERules {

	*checkParallelOctaves { |nextChord, data|
		var result = false;
		var indices = List();
		var octaves = [12, 24, 36, 48];
		var i, j;

		//"checkParallelOctaves".postln;

		if (data[\pChord].notNil) {

			i = 0;
			while { i < (MEVoice.voiceNumber - 1) } {
				j = i + 1;
				while { j < MEVoice.voiceNumber } {
					if (octaves.includes((data[\pChord][i].midi - data[\pChord][j].midi).abs)) {
						indices.add([i, j]);
					};
					j = j + 1;
				};
				i = i + 1;	
			};

			indices.do { |i|
				result = result || (
					((data[\pChord][i[0]].midi - data[\pChord][i[1]].midi).abs ==
					(nextChord[i[0]].midi - nextChord[i[1]].midi).abs) &&
					(data[\pChord][i[0]].midi != nextChord[i[0]].midi)
				)
			};
			^result.not;
		} {
			^true;
		};
	}

	/****************************************************************************************/

	*checkParallelFifths { |nextChord, data|
		var result = false;
		var indices = List();
		var fifths = [7, 19, 31, 43];
		var i, j;

		//"checkParallelFifths".postln;

		if (data[\pChord].notNil) {
			i = 0;
			while { i < (MEVoice.voiceNumber - 1) } {
				j = i + 1;
				while { j < MEVoice.voiceNumber } {
					if (fifths.includes((data[\pChord][i].midi - data[\pChord][j].midi).abs)) {
							indices.add([i, j]);
						};
						j = j + 1;
					};
					i = i + 1;
				};

				indices.do { |i|
					result = result || (
						((data[\pChord][i[0]].midi - data[\pChord][i[1]].midi).abs ==
						(nextChord[i[0]].midi - nextChord[i[1]].midi).abs) &&
						(data[\pChord][i[0]].midi != nextChord[i[0]].midi)
					)
				};
				^result.not;
			} {
				^true;
			}
	}

	/****************************************************************************************/

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

		if (rules[\enforceParallelFifths] ) {
			result = result && MEChordRules.checkParallelFifths(nextChord, data);
		};
		if (rules[\enforceParallelOctaves] )  {
			result = result && MEChordRules.checkParallelOctaves(nextChord, data);
		};
		^result && MEChordRules.checkChordIsComplete(nextChord, data);
	}

	/****************************************************************************************/

	*checkUnisons { |nextChord, menote, i|

		//"checkUnisons".postln;

		^(nextChord[i] == nextChord[i - 1]).not;
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
			((nextChord[i].midi - nextChord[i - 1].midi).abs < 12);
		} {
			^(nextChord[i].midi >= nextChord[i - 1].midi) &&
			((nextChord[i].midi - nextChord[i - 1].midi).abs < 12);
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
		var result = true;

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
			if (rules[\enforceUnisonProhibition]) {
				result = result && this.checkUnisons(nextChord, menote, i);
			};
			^(result && this.checkVoiceSpacing(nextChord, data, i) &&
			this.checkDuplicateDegrees(nextChord, menote, data));
		};
		^true;
	}
}
