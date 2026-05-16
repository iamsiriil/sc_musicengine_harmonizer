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
~p = ["FM3M6P5", "F#o7", "Gm3P5m7", "DM3A5m7", "CP4P5m7", "CM3m6m7A9", "FM3M6M9"];
~r = Array.new(~p.size);
~v = 7;

~p.do { |c, i|
	var temp;

	temp = if ( i == 0 ) {
		MEChord(c, prevChord: nil, voiceNum: ~v).chords.choose;
	} {
		MEChord(
			c,
			prevChord: ~r[i - 1],
			ruleProf: [enforceUnisonProhibition: false],
			voiceNum: ~v
		).chord;
	};
	~r.add(temp);
};

"\nProgression [".postln;
~r.do { |c| c.postln };
"]".postln;
)

/****************************************************************************************/
// Create a routine
(
Routine({
	~r.do { |c|
		c.names.join(", ").postln;
		Synth(\fm_chord, [
			\chord, c.freq,
			\iScale, 0.5,
			\index, 2,
			\mRatio, 1,
			\cRatio, 1,
			\rel, 3
		]);
		2.wait;
	}
}).play;
)

