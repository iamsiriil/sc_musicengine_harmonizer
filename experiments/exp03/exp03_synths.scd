/****************************************************************************************/
// EXPERIMENT 03 : Chopin, Prelude in E minor - Synths
/****************************************************************************************/
// FM Organ
(
SynthDef(\fm, {
	arg freq=400, amp=0.5, atk=0.5, dec=2, gate=1,
	mRt=2, cRt=2, pan=0, out=0;
	var aEnv = EnvGen.kr(
		Env.new(
			[1, 10, 1000],
			[atk, dec],
			[-3, 5]
		),
		gate
	);
	var env = EnvGen.kr(Env.asr(atk, releaseTime: dec), gate, doneAction: 2);
	var mod = SinOsc.ar(freq * mRt, mul: aEnv);
	var car = SinOsc.ar((freq) * cRt + mod);
	var line = Line.kr(pan * -1, pan, (atk + dec));
	car = HPF.ar(car, 1000);
	car = car * SinOsc.ar(Line.kr(1, 5), mul: 0.5);
	car = car * env * amp;
	car = Pan2.ar(car, line);
	Out.ar(out, car);
}).add;

/****************************************************************************************/
// Bass

SynthDef(\bass, {
	arg freq=400, amp=0.3, mAmp=165, atk=0.1, rel=2,
	mRt=0.25, cRt=1, pan=0, out=0, gate=1;
	var env = EnvGen.kr(Env.asr(atk, releaseTime: rel), gate, doneAction: 2);
	var mod = SinOsc.ar(freq * mRt, mul: mAmp);
	var car = SinOsc.ar(freq * cRt + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(out, car);
}).add;

/****************************************************************************************/
// Solo playing theme

SynthDef(\solo, {
	arg freq=400, amp=0.3, mAmp=18, atk=0.1, rel=2,
	mRt=0.5, cRt=1.5, pan=0, out=0, gate=1;
	var env = EnvGen.kr(Env.asr(atk, releaseTime: rel), gate, doneAction: 2);
	var mod = Saw.ar(freq * mRt, mul: freq * mAmp);
	var car = SinOsc.ar(freq * cRt + mod);
	car = car * env * amp;
	car = PitchShift.ar(car, 0.1, 2, 0.00001);
	car = Pan2.ar(car, pan);
	Out.ar(out, car);
}).add;

/****************************************************************************************/
// Percussion
/****************************************************************************************/
// Kick

SynthDef(\kick, {
	arg freq=120, amp=0.8, out=0, pan=0, atk=0.001, rel=0.15;
	var env = Env.perc(atk, rel, curve: -9).kr(Done.freeSelf);
	var mod = SinOsc.ar(freq * 0.5, mul: 100);
	var car = SinOsc.ar(freq * 1 + mod);
	var ns = PinkNoise.ar(0.5);
	var env2 = Env.perc(atk, rel, curve: -4).kr(Done.freeSelf);
	var sig = SinOsc.ar((freq / 2) + (env2 * 100));
	car = Mix.ar([car, ns]);
	car = Mix.ar([car, sig]);
	car = car * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(out, car);
}).add;

/****************************************************************************************/
// Snare

SynthDef(\snare, {
	var env = Env.perc(\atk.ir(0.001), \rel.ir(0.3), curve: -9).kr(Done.freeSelf);
	var mod = SinOsc.ar(\freq.ir(440), mul: \freq.ir(440) * 1);
	var sig = Pulse.ar(\freq.ir(440) + mod) * env * \amp.ir(0.5);
	var nos = WhiteNoise.ar(0.6) * env;
	sig = Mix.ar([nos * 0.7, sig]);
	sig = LPF.ar(sig, \freq.ir(440) * 20);
	sig = Pan2.ar(sig, \pan.ir(0.0));
	Out.ar(\bus.ir(0), sig);
}).add;

/****************************************************************************************/
// Effects
/****************************************************************************************/
// Reverb

SynthDef(\rev, {
	arg out=0, in=0, revamp=0.3;
	var sig = In.ar(in, 2);
	var wet = FreeVerb2.ar(
		sig[0], sig[1],
		mix: 0.7,
		room: 0.4,
		damp: 0.85,
		mul: revamp
	);
	sig = sig + wet;
	Out.ar(out, sig);
}).add;

/****************************************************************************************/
// Mix

SynthDef(\mix, {
	arg amp=0.5, out=0;
	var mIn  = In.ar(4, 2);
	var bIn  = In.ar(6, 2);
	var cIn1 = In.ar(8, 2);
	var cIn2 = In.ar(10, 2);
	var cIn3 = In.ar(12, 2);
	var cIn4 = In.ar(14, 2);
	var kIn  = In.ar(16, 2);
	var sIn  = In.ar(18, 2);

	var vcs = Mix.ar([
		mIn * 0.25,
		bIn,
		cIn1 * 0.65,
		cIn2 * 0.65,
		cIn3 * 0.7,
		cIn4 * 0.85
	]);
	var drm = Mix.ar([kIn, sIn]);
	var mix = Mix.ar([vcs * 0.6, drm]);
	mix = mix * amp;
	Out.ar(out, mix);
}).add;
)