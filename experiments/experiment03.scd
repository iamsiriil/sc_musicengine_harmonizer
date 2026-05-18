/****************************************************************************************/
s.boot;
/****************************************************************************************/
// FM synth for playing chords
(
SynthDef(\fm_chord, {
	arg chord= #[0, 0, 0, 0, 0, 0, 0], mRatio=1, cRatio=1, index=1, iScale=3,
	amp=0.2, atk=0.01, rel=3, cAtk=4, cRel=(-4), pan=0;
	var iEnv = EnvGen.kr(
		Env.new(
			[index, index * iScale, index],
			[atk, rel],
			[cAtk, cRel]
		)
	);
	var env  = EnvGen.kr(Env.perc(atk, rel, curve: [cAtk, cRel]), doneAction: 2);
	var mod1 = SinOsc.ar(chord[0] * mRatio, mul: chord[0] * mRatio * iEnv);
	var mod2 = SinOsc.ar(chord[1] * mRatio, mul: chord[1] * mRatio * iEnv);
	var mod3 = SinOsc.ar(chord[2] * mRatio, mul: chord[2] * mRatio * iEnv);
	var mod4 = SinOsc.ar(chord[3] * mRatio, mul: chord[3] * mRatio * iEnv);
	var mod5 = SinOsc.ar(chord[4] * mRatio, mul: chord[4] * mRatio * iEnv);
	var mod6 = SinOsc.ar(chord[5] * mRatio, mul: chord[5] * mRatio * iEnv);
	var mod7 = SinOsc.ar(chord[6] * mRatio, mul: chord[6] * mRatio * iEnv);
	var car  = Mix.ar([
		SinOsc.ar(chord[0] * cRatio + mod1),
		SinOsc.ar(chord[1] * cRatio + mod2),
		SinOsc.ar(chord[2] * cRatio + mod3),
		SinOsc.ar(chord[3] * cRatio + mod4),
		SinOsc.ar(chord[4] * cRatio + mod5),
		SinOsc.ar(chord[5] * cRatio + mod6),
		SinOsc.ar(chord[6] * (cRatio) + mod7),
	]);
	car = car * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;
)

/****************************************************************************************/
// Create a progression
(
~p = ["Em", "C^7", "BP4P5m7", "B7", "D7", "BFr", "Bm3d5m7", "G#d4d5d7", "E7", "E-7", "C#o7",
	"A-7", "F#-7o5", "F#P4d5m7", "F#-7o5", "D#o7", "BM3P5m9", "D7", "D-7", "B-7o5", "G#o7",
	"CM3A5M7", "A-", "BP4P5m7", "B7", "F#-7o5", "A-", "B7", "F#-7o5", "A-", "B7",
	"Em", "C^7", "BP4P5m7", "BM3d5m7", "DGr", "G#m3P5d7", "G#o7", "E7", "EM3m6m7", "E-7", "A#o7", "A#o7", "F-7o5",
	"B7"
];
~d = [
	3, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1,
	2, 1, 1, 2, 1, 1, 4, 2, 1, 1,
	1, 3, 1, 1, 1, 1, 2, 1, 1, 4,
	3, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	2
];
//~p = ["E-7", "C#o7"];
~r = Array.new(~p.size);
~v = 5;

~p.do { |c, i|
	var temp;

	temp = if ( i == 0 ) {
		MEChord(c, prevChord: nil, voiceNum: ~v).chords.choose;
	} {
		MEChord(
			c,
			prevChord: ~r[i - 1],
			ruleProf: [enforceChordPosition: false],
			voiceNum: ~v
		).chord;
	};
	~r.add(temp);
};

"\nProgression [".postln;
~r.do { |c| c.postln };
"]".postln;
)
~r[~r.size - 2]
MEChord("C#o7", prevChord: ~r[~r.size - 2], voiceNum: ~v)
/****************************************************************************************/
// Create a routine
(
Routine({
	~r.do { |c, i|
		c.names.join(", ").postln;
		Synth(\fm_chord, [
			\chord, c.freq,
			\iScale, 0.5,
			\index, 2,
			\mRatio, 1,
			\cRatio, 1,
			\rel, 3
		]);
		~d[i].wait;
	}
}).play;
)
