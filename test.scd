
(
s.boot;
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
	\enforceUnisonProhibition:     true

	//\enforceVoiceCrossProhibition: true,
));
)

MEVoice.voiceNumber

// Only four to seven voices allowed.
// Number of voices must be greater or equal to
// number on degrees present in the range.
(
MEBacktrack.counter = 0;
~c = MEChord("C#M3P4m6m9", voiceNum: 7); // 7th chord, four degrees (P1, m3, P5, m7); five voices.
"Number of chords generated: ".post;
~c.chordSet.size.postln;
"Number of recursive calls:  ".post;
MEBacktrack.counter.postln;
)
s.boot
(
~routine = { |chordSet|

	Routine {
		chordSet.reverseDo { |c, i|
			//"Chord#% ".format(i).padRight(4).post;
			c.do{ |n|
				"% ".format(n.name(\m21)).padRight(6).post;
				Synth(\tone, [\freq, n.freq, \amp, 0.5]);
				0.25.wait;
			};
			"".postln;
			//0.5.wait;
		};
	}.play;
};
~routine.(~c.chordSet);
)

~r = MEChordRange00("F#-7")
