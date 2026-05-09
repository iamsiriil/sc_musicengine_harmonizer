MEChord {
	//var <chordData;
	var index;
	var <chords; // <- change to register (implement first resolution backtrack function)
	//var chord;


	*new { |symbol, prevChord, ruleProf, voiceNum| // <- backtrackAll = false
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

		if (newR.notNil) {
			MErules.toggleRules(newR);
		};

		/* 2. Initialize MEVoice */
		MEChord.setVoiceNumber(newN, noteRange.intervals);

		/* 3. Initialize chord data dictionary */
		chordData[\symbol]  = noteRange.symbol.asSymbol; // Always use the normalized symbol as a
		                                                 // SC Symbol and not the alias, if it exists).
		chordData[\degrees] = noteRange.intervals;       // Array of degrees present in range.
	//	chordData[\rules]   = newR;                      // Custom rule profile dictionary.
		chordData[\pChord]  = newP;                      // Previous chord as MENoteRange.

		/* 5. Get valid vocal ranges */
		chordData[\range] = MEChord.getChordVocalRange(chordData);           // Get sets of valid notes within vocal range.

		/* 6. Get chords */
		chords = MEChord.getChords(chordData).asArray;                             // Get collection of all possible solutions.

		/* 7. Convert each chord into a MENoteRange */
		chords.do { |n, i| chords[i] = MENoteRange.with(noteRange.meSymbol, *n) }; // Convert each solution into a MENoteRange object.

		/* 8. Assign a face chord */
		index = 0;
		//chord  = chords[index];                                                        // Assign first chord as object's facade.
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

			range   = MEVoice.range[v];

			temp = MESession.chordData[symbol].select { |n|
				(n.midi >= range[0]) && (n.midi <= range[1])
			}.asArray;

			dict[v] = temp;
		};

		// Sort by proximity to previous voice note
		// (bias twards small leaps and common tones ??)
		if (chordData[\pChord].notNil) {

			names.do { |v, i|

				// Get valid melodic leaps
				// if \enforceMelodicIntervals
				if (MERules.rules[\enforceMelodicIntervals].postln) {
					dict[v] = dict[v].select { |n|
						MEVoice.validIntervals.includes((chordData[\pChord][i].midi - n.midi).abs)
					};
				};

				// if \enforceCommonTone
				//		-> remove all except common tone
				// else
				//		-> Sort by proximity to previous note
				dict[v] = dict[v].sort { |a, b|
					(chordData[\pChord][i].midi - a.midi).abs <=
					(chordData[\pChord][i].midi - b.midi).abs
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
		if ((index >= 0) && (index < chords.size)) { index = index + 1 } { "Limit reached".warn }
	}

	/****************************************************************************************/

	prev {
		if ((index > 0) && (index < chords.size)) { index = index - 1 } { "Limit reached".warn }
	}
}
