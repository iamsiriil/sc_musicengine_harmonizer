MEChord {
	classvar <noteRange;
	classvar <vocalRange;
	classvar <chordDict;
	var <chord;

	*new { |symbol, voiceNum = 4|
		^super.new.init(symbol, voiceNum)
	}

	init { |newS, newN|

		"init".postln;

		MEVoice.voiceNumber = newN;

		noteRange  = MENoteRange(newS);
		MESession.chordData = noteRange;
		vocalRange = MEChord.getChordVocalRange;
		chordDict  = OrderedIdentitySet();

		MEChord.getChords();

		^this;
	}

	*getChordVocalRange {
		var names = MEVoice.voiceNames;
		var dict  = Dictionary();
		var range;

		"getChordVocalRange".postln;

		names.do { |v|

			range   = MEVoice.range[v];

			dict[v] = noteRange.notes.select { |n|
				(n.midi >= range[0]) && (n.midi <= range[1])
			};
		};
		^dict;
	}

	*getChords {
		var nextChord   = Array.fill(MEVoice.voiceNumber, {0});

		"getChords".postln;

		MEBacktrack.backtrackChords(this.vocalRange, nextChord, this.chordDict, 0);
	}

	chordDict {
		^chordDict;
	}

	noteRange {
		^noteRange;
	}
}