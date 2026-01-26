s.boot;

(
SynthDef(\tone, { |freq = 440, amp = 0.3|
	var env = EnvGen.kr(Env(
		levels:  [0, 1, 0],
		times:   [0.01, 1],
		curve:   [4, -4]
	),
	doneAction: 2
	);
	var sig = Pulse.ar(freq) * amp;
	sig = sig * env;
	sig = FreeVerb.ar(sig);
	Out.ar(0, Pan2.ar(sig, 0));
}).add;
)

// Only four voices allowed for now
(
~c = MEChord("F#-^7");
~c.noteRange.postln;
~c.chordDict.postln;
)

(
~routine = { |chordDict|

	Routine {
		chordDict.do { |c|
			"Chord: %".format(c).postln;
			c.do{ |n|
				Synth(\tone, [\freq, n.freq, \amp, 0.5]);
				0.25.wait;
			};
			1.wait;
		};
	}.play;
};
~routine.(~c.chordDict);
)

