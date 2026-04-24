MEChord {
	//var <chordData;
	var <chords;
	var <chord;


	*new { |symbol, prevChord, ruleProf, voiceNum|
		^super.new.init(symbol, prevChord, ruleProf, voiceNum)
	}

	*initClass { ^super.initClass }

	init { |newS, newP, newR, newN|
		var chordData = Dictionary();
		var noteRange;

		"init".postln;


		/* 1. Get note range */
		if ((noteRange = MESession.chordData[newS.asSymbol]).isNil) {
			noteRange = MENoteRange(newS);
			MESession.chordData[newS.asSymbol] = noteRange;
		};

		/* 2. Initialize chord data dictionary */
		chordData[\symbol]  = noteRange.symbol.asSymbol;
		chordData[\degrees] = noteRange.intervals;
		chordData[\rules]   = newR;

		/* 3. Initialize MEVoice class */
		if (newN.notNil) {
			MEVoice.noiceNumber = newN;
		} {
			MEVoice.voiceNumber = chordData[\degrees].size;
		};

		/* 4. Get valid vocal ranges */
		chordData[\range] = MEChord.getChordVocalRange(chordData, newP);

		/* 5. Get chords */
		chords = MEChord.getChords(chordData).asArray;

		/* 6. Convert each chord into a MENoteRange */
		chords.do { |n, i| chords[i] = MENoteRange.with(noteRange.meSymbol, *n) };

		/* 7. Assign a face chord */
		chord  = chords[0];

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