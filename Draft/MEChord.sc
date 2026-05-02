MEChord {
	//var <chordData;
	var <chords; // <- change to register (implement first resolution backtrack function)
	var <chord;


	*new { |symbol, prevChord, ruleProf, voiceNum| // <- backtrackAll = false
		^super.new.init(symbol, prevChord, ruleProf, voiceNum)
	}

	*initClass { ^super.initClass }

	init { |newS, newP, newR, newN|
		var chordData = Dictionary();
		//var newSymbol = MESymbol(newS);
		var noteRange;

		"init".postln;

		newS = MESymbol(newS);


		/* 1. Get note range */
		if ((noteRange = MESession.chordData[newS.symbol.asSymbol]).isNil) {
			noteRange = MENoteRange(newS.symbol);
			MESession.chordData[noteRange.symbol.asSymbol] = noteRange;
		};

		/* 2. Initialize chord data dictionary */
		chordData[\symbol]  = noteRange.symbol.asSymbol; // Always use the normalized symbol as a
		                                                 // SC Symbol and not the alias, if it exists).
		chordData[\degrees] = noteRange.intervals;       // Array of degrees present in range.
		chordData[\rules]   = newR;                      // Custom rule profile dictionary.
		chordData[\pChord]  = newP;                      // Previous chord as MENoteRange.

		/* 3. Initialize MEVoice class */
		if (newN.isNil) {
			MEVoice.voiceNumber = chordData[\degrees].size; // Get voice number from number of degrees.
		} {
			if ((newN >= chordData[\degrees].size) && ((newN >= 4) && (newN <= 7))) {
				MEVoice.voiceNumber = newN;
			} {
				Error("% is not a valid number of voices.".format(newN)).throw;
			};
		};

		/* 4. Get valid vocal ranges */
		chordData[\range] = MEChord.getChordVocalRange(chordData, newP);           // Get sets of valid notes within vocal range.

		/* 5. Get chords */
		chords = MEChord.getChords(chordData).asArray;                             // Get collection of all possible solutions.

		/* 6. Convert each chord into a MENoteRange */
		chords.do { |n, i| chords[i] = MENoteRange.with(noteRange.meSymbol, *n) }; // Convert each solution into a MENoteRange object.

		/* 7. Assign a face chord */
		chord  = chords[0];                                                        // Assign first chord as object's facade.

		^this;
	}

	printOn { |stream|
		//stream << "MEChord";
		stream << chord;
		//stream << "";
	}


	/****************************************************************************************/

	*getChordVocalRange { |chordData, prevChord|
		var symbol = chordData[\symbol];
		var names  = MEVoice.voiceNames;
		var dict   = Dictionary.new();
		var range;

		"getChordVocalRange".postln;

		names.do { |v|

			range   = MEVoice.range[v];

			dict[v] = MESession.chordData[symbol].select { |n|
				(n.midi >= range[0]) && (n.midi <= range[1])
			}.as(OrderedIdentitySet);
		};

		// Sort by proximity to previous voice note
		// (bias twards small leaps and common tones ??)
		if (prevChord.notNil) {

			names.do { |v, i|
				dict[v] = dict[v].sort { |a, b|
					(prevChord[i].midi - a.midi).abs <= (prevChord[i].midi - b.midi).abs;
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

		//this.chords = OrderedIdentitySet();

		MEBacktrack.backtrackChords(chordData, nextChord, chords, 0);

		^chords;
	}

	/****************************************************************************************/

	/*chords {
		^this.chords;
	}*/

	/****************************************************************************************/

	/*chordData {
		^chordData;
	}*/

	/****************************************************************************************/

	vocalRange {
		^this.chordData[\range];
	}

	/****************************************************************************************/

	/*chord {
		^chord;
	}*/
}