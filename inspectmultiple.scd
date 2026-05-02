/****************************************************************************************/
// Inspect Sequence of Chords
/****************************************************************************************/
// Simple function to generate progressions from MEChord
(
~p0 = ["C", "F7", "Bb", "G", "Cm"]; // Chord progression
~cp0 = Array.new(~p0.size);         // New array from realized progression
~nv0 = 5;                           // Number of voices

// Simple loop that ceates a progression
~p0.do { |c, i|
	var temp;

	if (i == 0) {
		temp = MEChord(c, prevChord: nil, voiceNum: ~nv0).chords.choose; // No previous chord
		~cp0.add(temp);
	} {
		temp = MEChord(c, prevChord: ~cp0[i - 1], voiceNum: ~nv0).chords.choose; // Previous chord
		~cp0.add(temp)
	};
};
)

(
Routine({
	var syn;

	~cp0.do { |c|
		c.postln;
		c.do { |n|
			//n.postln;
			syn = Synth(\tone, [\freq, n.freq]);
		};
		1.wait;
	}
}).play
)