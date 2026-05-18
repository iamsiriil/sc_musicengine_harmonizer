/****************************************************************************************/
// Very long progression experiment:
// Complete harmony from Chopin's Etude Op.10 Nº1

s.boot;

/****************************************************************************************/
// FM synth for playing chords
(
SynthDef(\fm_chord, {
	arg chord= #[0, 0, 0, 0, 0], mRatio=1, cRatio=1, index=1, iScale=3,
	amp=0.2, atk=0.01, rel=3, cAtk=4, cRel=(-4), pan=0, gate=0;
	var iEnv = EnvGen.kr(
		Env.new(
			[index, index * iScale, index],
			[atk, rel],
			[cAtk, cRel]
		),
		gate: gate
	);
	var env  = EnvGen.kr(
		Env.new(
			[0, 1, 0],
			[atk, rel],
			[cAtk, cRel],
			releaseNode: 1
		),
		gate: gate,
		doneAction: 2
	);
	var mod1 = SinOsc.ar(chord[0] * mRatio, mul: chord[0] * mRatio * iEnv);
	var mod2 = SinOsc.ar(chord[1] * mRatio, mul: chord[1] * mRatio * iEnv);
	var mod3 = SinOsc.ar(chord[2] * mRatio, mul: chord[2] * mRatio * iEnv);
	var mod4 = SinOsc.ar(chord[3] * mRatio, mul: chord[3] * mRatio * iEnv);
	var mod5 = SinOsc.ar(chord[4] * mRatio, mul: chord[4] * mRatio * iEnv);
//	var mod6 = SinOsc.ar(chord[5] * mRatio, mul: chord[5] * mRatio * iEnv);
//	var mod7 = SinOsc.ar(chord[6] * mRatio, mul: chord[6] * mRatio * iEnv);
	var car  = Mix.ar([
		SinOsc.ar(chord[0] * cRatio + mod1),
		SinOsc.ar(chord[1] * cRatio + mod2),
		SinOsc.ar(chord[2] * cRatio + mod3),
		SinOsc.ar(chord[3] * cRatio + mod4),
		SinOsc.ar(chord[4] * cRatio + mod5),
	// 	SinOsc.ar(chord[5] * cRatio + mod6),
	//	SinOsc.ar(chord[6] * (cRatio) + mod7),
	]);
	car = LPF.ar(car, 5000);
	car = car * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;
)

/****************************************************************************************/
// Create a progression
(
~p = [
	"C", "F", "F#-7o5", "D7", "G", "D7", "Dm3P4d5m7", "G7", "GM3A5m7",               // S1
	"C", "F", "F#-7o5", "Gs4", "G", "Cs2", "C",                                      // S2
	"F^7", "Bo", "B-7o5", "E7", "A-", "A-7", "F^7", "BFr", "Es4", "E",               // S3
	"A7", "DM2P4P5m7", "D7", "GP4P5m7", "G7", "C7", "C-7o5", "F7", "Ab-",            // S4
	"Bb7", "EFr", "A", "A", "D7", "GP4P5m7", "G7", "C^7", "FA4P5M7", "F^7",          // S5
	"B-7o5", "E-7", "A-7", "D-7", "G7", "C^7", "F^7", "B-7o5", "B7", "E", "E", "G7", // S6
	"C", "F", "F#-7o5", "D7", "G", "D7", "D-7o5", "G7", "GM3A5m7",                   // S7
	"C", "F", "F#-7o5", "F#o7", "Gs4", "G", "D7", "F7", "BFr",                       // S8
	"E", "D-7", "G7", "C", "C7", "F#o7", "Bo7", "C", "F#o7", "Bo7",                  // S9
	"Eo7", "F#m3d6d7", "F#o7", "D-7o5", "G7", "C"                                    // S10
];
~d = [
	4, 2, 1.5, 0.5, 2, 2, 2, 1.5, 0.5,      // S1
	4, 2, 2, 2, 2, 2, 2,                    // S2
	2, 1, 1, 2, 1, 1, 2, 2, 2, 2,           // S3
	2, 1.5, 0.5, 2, 2, 2, 2, 2, 2,          // S4
	2, 2, 2, 2, 2, 1.5, 0.5, 2, 1.5, 0.5,   // S5
	2, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1.5, 0.5, // S6
	4, 2, 1.5, 0.5, 2, 2, 2, 1.5, 0.5,      // S7
	4, 2, 1, 1, 2, 2, 2, 1, 1,              // S8
	4, 2, 2, 1, 1, 1, 1, 2, 1, 1,           // S9
	2, 1.5, 0.5, 2, 2, 4                    // S10
];

~p.size.postln;
~d.size.postln;

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
			ruleProf: [enforceUnisonProhibition: false, enforceChordPosition: true],
			voiceNum: ~v
		).chord;
	};
	~r.add(temp);
};

"\nProgression [".postln;
~r.do { |c| c.postln };
"]".postln;
)
MESession.chordData.keys.size
~p.size
/****************************************************************************************/
// Create a routine
(
~c = TempoClock(100/60);
Routine({
	var syn;

	~r.do { |c, i|
		c.names.join(", ").postln;
		syn = Synth(\fm_chord, [
			\chord, c.freq,
			\iScale, 0.2,
			\index, 2,
			\mRatio, 1,
			\cRatio, 2,
			\atk, 0.05,
			\rel, 0.5,
			\gate, 1,
			\amp, 0.1
		]);
		~d[i].wait;
		syn.set(\gate, 0);
	}
}).play(~c);
)
