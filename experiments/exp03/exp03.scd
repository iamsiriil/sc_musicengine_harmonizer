/****************************************************************************************/
(
s.waitForBoot({
	"./exp03_resources.scd".loadRelative;
	"./exp03_sustain.scd".loadRelative;
});
)
/****************************************************************************************/
// Create a progression (progression split into two sections)
(
~c1 = Array.new(~p1.size);
~c2 = Array.new(~p2.size);
~v = 4;

// First section
~p1.do { |c, i|
	var temp;

	temp = if ( i == 0 ) {
		MEChord(
			c,
			prevChord: nil,
			ruleProf: nil,
			voiceNum: ~v
		).chords.choose;
	} {
		MEChord(
			c,
			prevChord: ~c1[i - 1],
			ruleProf: [enforceChordPosition: false, enforceUnisonProhibition: false],
			voiceNum: ~v
		).chord;
	};
	~c1.add(temp);
};
~return1 = ~getVoices.(~c1, ~d1, ~v); // Get voices with sustained common tones

// Second section
~p2.do { |c, i|
	var temp;

	temp = if ( i == 0 ) {
		MEChord(c, prevChord: nil, voiceNum: ~v).chords.choose;
	} {
		MEChord(
			c,
			prevChord: ~c2[i - 1],
			ruleProf: [enforceChordPosition: false, enforceUnisonProhibition: false],
			voiceNum: ~v
		).chord;
	};
	~c2.add(temp);
};
~return2 = ~getVoices.(~c2, ~d2, ~v); // Get voices with sustained common tones

"\nProgression #1 [".postln;
~c1.do { |c| c.postln };
"]".postln;

"\nProgression #2 [".postln;
~c2.do { |c| c.postln };
"]".postln;
)
~c1
/****************************************************************************************/
// Create a routine
(
Routine({
	~c1.do { |c, i|

		// First section played as chords
		c.names.join(", ").postln;
		Synth(\fm_chord, [
			\chord, c.freq,
			\iScale, 0.5,
			\index, 2,
			\mRatio, 1,
			\cRatio, 1,
			\rel, 3
		]);
		~d1[i].wait;
	};

//	~c2.do { |c, i|
//		c.names.join(", ").postln;
//		Synth(\fm_chord, [
//			\chord, c.freq,
//			\iScale, 0.5,
//			\index, 2,
//			\mRatio, 1,
//			\cRatio, 1,
//			\rel, 3
//		]);
//		~d2[i].wait;
//	}

	// Second section played as counterpoint
	Ppar([
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((~return2[0] >> 12).midi),
			\dur, ~return2[0].asPseq(\dur),
			\legato, 0.99
		),
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((~return2[1] >> 12).midi),
			\dur, ~return2[1].asPseq(\dur),
			\legato, 0.99
		),
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((~return2[2] >> 12).midi),
			\dur, ~return2[2].asPseq(\dur),
			\legato, 0.99
		),
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((~return2[3] >> 12).midi),
			\dur, ~return2[3].asPseq(\dur),
			\legato, 0.99
		),
	]).play
}).play;
)

(
Ppar([
	Pbind(
		\instrument, \sin,
		\midinote, Pseq((~return1[0] >> 12).midi),
		\dur, ~return1[0].asPseq(\dur),
		\legato, 0.99
	),
	Pbind(
		\instrument, \sin,
		\midinote, Pseq((~return1[1] >> 12).midi),
		\dur, ~return1[1].asPseq(\dur),
		\legato, 0.99
	),
	Pbind(
		\instrument, \sin,
		\midinote, Pseq((~return1[2] >> 12).midi),
		\dur, ~return1[2].asPseq(\dur),
		\legato, 0.99
	),
	Pbind(
		\instrument, \sin,
		\midinote, Pseq((~return1[3] >> 12).midi),
		\dur, ~return1[3].asPseq(\dur),
		\legato, 0.99
	),
//	Pbind(
//		\instrument, \sin,
//		\midinote, Pseq((~return1[4] >> 12).midi),
//		\dur, ~return1[4].asPseq(\dur),
//		\legato, 0.99
//	),
]).play;
)
