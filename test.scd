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

MERules.listRules

(
MERules.changeRules((
	\enforceChordPosition:         true,
	\enforceRootPosition:          true,
	\enforceFirstInversion:        false,
	\enforceSecondInversion:       false,
	\enforceThirdInversion:        false,
	\enforceExtendedInversion:     false,
	//\enforceVoiceCrossProhibition: true,
));
)

MEVoice.voiceNumber

// Only four to seven voices allowed
(
MEBacktrack.counter = 0;
~c = MEChord("C-^7", 5);
//~c.noteRange.postln;
~c.chordSet.postln;
~c.chordSet.size.postln;
MEBacktrack.counter;
)

(
~routine = { |chordSet|

	Routine {
		chordSet.do { |c, i|
			//"Chord#% ".format(i).padRight(4).post;
			c.do{ |n|
				"% ".format(n.name).padRight(4).post;
				Synth(\tone, [\freq, n.freq * 2, \amp, 0.5]);
				0.25.wait;
			};
			"".postln;
			0.5.wait;
		};
	}.play;
};
~routine.(~c.chordSet);
)

(
~int = [\P1, \M3, \P5, \P1, \M3, \M3];
~int.select { |a, b| var n; n = ~int.count { |i| i == a}; (n > 1) && (n < 4) };
)