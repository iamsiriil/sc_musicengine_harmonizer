MEChord {
	var index;
	var <chords;

	*new { |symbol, prevChord, ruleProf, voiceNum|
		^super.new.init(symbol, prevChord, ruleProf, voiceNum)
	}

	*initClass { ^super.initClass }

	init { |newS, newP, newR, newN|
		var chordData = Dictionary();
		var noteRange;

		"init".postln;

		newS = MESymbol(newS);

		/* 1. Get note range */
		if ((noteRange = MESession.chordData[newS.symbol.asSymbol]).isNil) {
			noteRange = MENoteRange(newS.symbol);
			MESession.chordData[noteRange.symbol.asSymbol] = noteRange;
		};

		/* 2. Toggle rules */
		if (newR.notNil) {
			MERules.toggleRules(newR);
		};

		/* 3. Set voice number */
		MEChord.setVoiceNumber(newN, noteRange.intervals);

		/* 4. Initialize data dictionary */
		chordData[\symbol]  = noteRange.symbol.asSymbol;
		chordData[\degrees] = noteRange.intervals;                   // Array of degrees present in range.
		chordData[\pChord]  = newP;                                  // Previous chord as MENoteRange.
		chordData[\range]   = MEChord.getChordVocalRange(chordData); // Get valid notes for each of the voices

		/* 5. Get chords */
		chords = MEChord.getChords(chordData).asArray;                             // Get collection of all possible solutions.

		/* 6. Convert each chord into a MENoteRange */
		chords.do { |n, i| chords[i] = MENoteRange.with(noteRange.meSymbol, *n) }; // Convert each solution into a MENoteRange object.

		/* 7. Assign a face chord */
		index = 0;
		MERules.resetRules;

		^this;
	}

	/****************************************************************************************/

	printOn { |stream|
		stream << this.chord;
	}

	/****************************************************************************************/

	*setVoiceNumber { |newN, degrees|
		var size = degrees.size;

		"setVoiceNumber".postln;
		
		if (newN.isNil) {
			case
			{ size < 4 } {
				MEVoice.voiceNumber = 4;
			} 
			{ size >= 4 && size <= 7 } {
				MEVoice.voiceNumber = size;
			} {
				Error("Note Range should not have more than 7 degrees.").throw
			};
		} {
			if (newN >= 4 && newN <= 7) {
				MEVoice.voiceNumber = newN;
			} {
				Error("% is not a valid number of voices. 4-7.").throw;
			};
		}
	}

	/****************************************************************************************/

	*getChordVocalRange { |chordData|
		var symbol = chordData[\symbol];
		var names  = MEVoice.voiceNames;
		var dict   = Dictionary.new();
		var range, temp;

		"getChordVocalRange".postln;

		names.do { |v, i|

			range = MEVoice.range[v];
			temp  = MESession.chordData[symbol].select { |n|
				(n.midi >= range[0]) && (n.midi <= range[1])
			}.asArray;

			dict[v] = temp;
		};

		if (chordData[\pChord].notNil) {

			names.do { |v, i|
				// if \enforceMelodicIntervals -> remove invalid intervals
				if (MERules.rules[\enforceMelodicIntervals]) {
					dict[v] = dict[v].select { |n|
						MEVoice.validIntervals.includes((chordData[\pChord][i].midi - n.midi).abs);
					};
				};

				// if \enforceCommonTone -> remove all except common tone
				if (MERules.rules[\enforceCommonTones]) {
					var name = chordData[\pChord][i].name;
					if (dict[v].any { |n| n.name == name }) {
						dict[v] = dict[v].select { |n| n.name == name };
					};
				} {
					// else -> Sort by proximity to previous note
					dict[v] = dict[v].sort { |a, b|
						(chordData[\pChord][i].midi - a.midi).abs <=
						(chordData[\pChord][i].midi - b.midi).abs
					};
				};
			};
		};

		^dict;
	}

	/****************************************************************************************/

	*getChords { |chordData|
		var nextChord = Array.fill(MEVoice.voiceNumber, {0});
		var chords = OrderedIdentitySet();

		"getChords".postln;

		MEBacktrack.backtrackChords(chordData, nextChord, chords, 0);

		^chords;
	}

	/****************************************************************************************/

	chord {
		^chords[index];
	}

	/****************************************************************************************/

	next {
		if ((index >= 0) && (index < chords.size)) {
			index = index + 1;
		} {
			"Limit reached".warn;
		};
		^chords[index];
	}

	/****************************************************************************************/

	prev {
		if ((index > 0) && (index < chords.size)) {
			index = index - 1;
		} {
			"Limit reached".warn;
		};
		^chords[index];
	}
}
