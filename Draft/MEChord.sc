MEChord {
	classvar <chordData;
	classvar <vocalRange;
	classvar <>chordSet;
	classvar <>chord;

	*new { |symbol, voiceNum = 4|
		^super.new.init(symbol, voiceNum)
	}

	init { |newS, newN|
		var noteRange;

		"init".postln;

		noteRange = MENoteRange(newS);
		MEVoice.voiceNumber = newN;

		chordData = Dictionary[
			\symbol  -> noteRange.symbol.asSymbol,
			\degrees -> noteRange.intervals,
		];

		MESession.chordData[chordData[\symbol]] = noteRange;

		chordData[\range] = MEChord.getChordVocalRange(chordData[\symbol]);
		MEChord.getChords();

		chordSet = chordSet.asArray;
		chord    = chordSet[0];

		^this;
	}

	/****************************************************************************************/

	*getChordVocalRange {
		var symbol = this.chordData[\symbol];
		var names  = MEVoice.voiceNames;
		var dict   = Dictionary();
		var range;

		"getChordVocalRange".postln;

		names.do { |v|

			range   = MEVoice.range[v];

			dict[v] = MESession.chordData[symbol].select { |n|
				(n.midi >= range[0]) && (n.midi <= range[1])
			}.as(OrderedIdentitySet);
		};
		^dict.postln;
	}

	/****************************************************************************************/

	*getChords {
		var nextChord = Array.fill(MEVoice.voiceNumber, {0});

		"getChords".postln;

		this.chordSet = OrderedIdentitySet();

		MEBacktrack.backtrackChords(this.chordData, nextChord, this.chordSet, 0);
	}

	/****************************************************************************************/

	chordSet {
		^chordSet;
	}

	/****************************************************************************************/

	chordData {
		^chordData;
	}

	/****************************************************************************************/

	vocalRange {
		^vocalRange;
	}

	/****************************************************************************************/

	chord {
		^chord;
	}
}