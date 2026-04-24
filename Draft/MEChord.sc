MEChord {
	//var <chordData;
	var <chords;
	var <chord;


	*new { |symbol, prevChord, voiceNum = 4|
		^super.new.init(symbol, prevChord, voiceNum)
	}

	*initClass { ^super.initClass }

	init { |newS, newP, newN|
		var chordData = Dictionary();
		var noteRange;

		"init".postln;

		MEVoice.voiceNumber = newN;

		if ((noteRange = MESession.chordData[newS.asSymbol]).isNil) {
			noteRange = MENoteRange(newS);
		};

		chordData[\symbol] = noteRange.symbol.asSymbol;
		chordData[\degrees] = noteRange.intervals;

		if (MESession.chordData[chordData[\symbol]].isNil) {
			MESession.chordData[chordData[\symbol]] = noteRange;
		};
		chordData[\range] = MEChord.getChordVocalRange(chordData, newP);

		chords = MEChord.getChords(chordData).asArray;

		chords.do { |n, i| chords[i] = MENoteRange.with(noteRange.meSymbol, *n) };
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