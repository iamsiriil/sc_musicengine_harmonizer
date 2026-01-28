MEChord {
	classvar <noteRange;
	classvar <vocalRange;
	classvar <chordSet;
	var <chord;

	*new { |symbol, voiceNum = 4|
		^super.new.init(symbol, voiceNum)
	}

	init { |newS, newN|

		//"init".postln;

		MEVoice.voiceNumber = newN;

		noteRange  = MENoteRange(newS);
		MESession.chordData = noteRange;
		chordSet  = OrderedIdentitySet();

		vocalRange = MEChord.getChordVocalRange;
		MEChord.getChords();

		^this;
	}

	*getChordVocalRange {
		var names = MEVoice.voiceNames;
		var dict  = Dictionary();
		var range;

		//"getChordVocalRange".postln;

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

		//"getChords".postln;

		MEBacktrack.backtrackChords(this.vocalRange, nextChord, this.chordSet, 0);
	}

	chordSet {
		^chordSet;
	}

	noteRange {
		^noteRange;
	}

	vocalRange {
		^vocalRange;
	}
}