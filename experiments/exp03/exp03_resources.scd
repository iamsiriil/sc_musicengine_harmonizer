/****************************************************************************************/
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

SynthDef(\sin, {
	arg freq=500, amp=0.5, atk=0.1, dec=0.1, sus=0.6, rel=0.2, pan=0, gate=1;
	var env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
	var sig = SinOsc.ar(freq) * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;

/****************************************************************************************/

~p1 = [
	"Em", "C^7", "BP4P5m7", "B7", "D7", "BFr", "Bm3d5m7", "G#d4d5d7", "E7", "E-7", "C#o7",  // S1
	"A-7", "F#-7o5", "F#P4d5m7", "F#-7o5", "D#o7", "BM3P5m9", "D7", "D-7", "B-7o5", "G#o7", // S2
	"CM3A5M7", "A-", "BP4P5m7", "B7", "F#-7o5", "A-", "B7", "F#-7o5", "A-", "B7",           // S3
];

~p2 = [
	"E-", "C^7", "BP4P5m7", "BM3d5m7", "D#Gr", "G#m3P5d7", "G#o7", "E7", "CM3A5M9", "E-7", "A#o7", "A#o7", "F#-7o5", // S4
	"BP4P5", "D#o7", "GM3A5M7", "E-", "A-", "F#-7o5", "Bs4", "Am", "Bs4", "Am", "Bs4", "B", "B7",                    // S5
	"C", "CM3m7", "F#-7o5", "Es4", "E","E-", "Em3P5M9", "A#Gr", "Bs4", "B", "E-"                                     // S6
];

~d1 = [
	3, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, // S1
	2, 1, 1, 2, 1, 1, 4, 2, 1, 1,    // S2
	1, 3, 1, 1, 1, 1, 2, 1, 1, 4,    // S3
];

~d2 = [
	3, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,         // S4
	0.5, 1.5, 0.5, 1.5, 1, 1, 1, 1, 2, 2, 2, 1, 1, // S5
	2, 1, 1, 1, 1, 1, 1, 4, 2, 2, 1                // S6
];
)
