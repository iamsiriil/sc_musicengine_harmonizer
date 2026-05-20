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

MERules.resetDefault;

// First section
~p1.do { |c, i|
	var temp;

	temp = if ( i == 0 ) {
		MEChord(
			c,
			prevChord: nil,
			ruleProf: [enforceChordPosition: true, enforceFirstInversion: false, enforceSecondInversion: true],
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

/****************************************************************************************/
// Create a routine
(
~accomp = { |seg1, seg2, dur1|

	Routine({
		1.wait;
		seg1.do { |c, i|

			// First section played as chords
			c.names.join(", ").postln;
			Synth(\fm_chord, [
				\chord, c.freq,
				\iScale, 0.5,
				\index, 2,
				\mRatio, 1,
				\cRatio, 1,
				\rel, 3,
				\amp, 0.1
			]);
			dur1[i].wait;
		};

		// Second section played as counterpoint
		3.wait;
		Ppar([
			Pbind(
				\instrument, \sin,
				\midinote, Pseq((seg2[0] >> 12).midi),
				\dur, seg2[0].asPseq(\dur),
				\legato, 0.99
			),
			Pbind(
				\instrument, \sin,
				\midinote, Pseq((seg2[1] >> 12).midi),
				\dur, seg2[1].asPseq(\dur),
				\legato, 0.99
			),
			Pbind(
				\instrument, \sin,
				\midinote, Pseq((seg2[2] >> 12).midi),
				\dur, seg2[2].asPseq(\dur),
				\legato, 0.99
			),
			Pbind(
				\instrument, \sin,
				\midinote, Pseq((seg2[3] >> 12).midi),
				\dur, seg2[3].asPseq(\dur),
				\legato, 0.99
			),
		]).play(~clock, quant: 1);
	});
};
)

/****************************************************************************************/

(
~clock = TempoClock.new(50/60);

Pbind(\midinote, ~m.asPseq(\midi), \dur, ~m.asPseq(\dur), \amp, 0.23).play(~clock, quant: 0);

Routine({
	1.wait;
	Pbind(
		\midinote, Pseq(~b.midi),
		\dur, ~b.asPseq(\dur),
		\amp, 0.5
	).play(~clock, quant: 0)
}).play(~clock, quant: 0);

Routine({
	1.wait;
	Ppar([
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((~return1[0] >> 12).midi),
			\dur, ~return1[0].asPseq(\dur),
			\legato, 0.99,
			\amp, 0.05
		),
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((~return1[1] >> 12).midi),
			\dur, ~return1[1].asPseq(\dur),
			\legato, 0.99,
			\amp, 0.06
		),
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((~return1[2] >> 12).midi),
			\dur, ~return1[2].asPseq(\dur),
			\legato, 0.99,
			\amp, 0.08
		),
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((~return1[3] >> 12).midi),
			\dur, ~return1[3].asPseq(\dur),
			\legato, 0.99,
			\amp, 0.1
		)
	]).play(~clock, quant: 0);
}).play(~clock, quant:0);
)

/****************************************************************************************/

(
~clock = TempoClock(60/60);

~r = {
	var syn, dur;

	Routine({

		~m.do { |n, i|
			dur = n.get(\dur);

			if (syn.notNil) {
				syn.set(\gate, 0);
			};

			syn = Synth(\default, [\freq, n.freq, \gate, 1, \amp, 0.3]);
			dur.wait;
		};

		if (syn.notNil) { syn.set(\gate, 0) };
	});
};

~r.().play(~clock, quant: 0);
~accomp.(~c1, ~return2, ~d1).play(~clock, quant: 0);
)
