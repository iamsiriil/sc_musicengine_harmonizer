/****************************************************************************************/
// Inspect Sequence of Chords
/****************************************************************************************/
// Simple function to generate progressions from MEChord
(
~p0 = ["CM3M6M9", "Eb-9", "F-9", "GM3m7m9m13", "CM3M7M9A11"]; // Chord progression
//~p0 = ["F-", "Bb-7", "Fs4", "CP4P5m7", "C7", "Fs4", "F-"];
~cp0 = Array.new(~p0.size);         // New array from realized progression
~nv0 = 5;                           // Number of voices

// Simple loop that ceates a progression
~p0.do { |c, i|
	var temp;

	temp = if ( i == 0 ) {
		MEChord(c, prevChord: nil, voiceNum: ~nv0).chords.choose; // No previous chord
	} {
		MEChord(c, prevChord: ~cp0[i - 1], voiceNum: ~nv0).chord; // Previous chord
	};
	~cp0.add(temp)
};

"\nProgression: ".postln;
~cp0.do { |c| c.postln };
)

/****************************************************************************************/
(
Routine({
	var syn;

	~cp0.do { |c|

		c.postln;
		c.do { |n|
			syn = Synth(\tone, [\freq, n.freq]);
		};
		1.wait;
	}
}).play
)

/****************************************************************************************/

MERules.listRules
MERules.resetDefault
MERules.default[\enforceChordPosition]
