(
s.waitForBoot{
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

	MERules.changeRules((
		enforceChordPosition:         true,
		enforceRootPosition:          true,
		enforceFirstInversion:        false,
		enforceSecondInversion:       false,
		enforceThirdInversion:        false,
		enforceExtendedInversion:     false,
		enforceUnisonProhibition:     true

		//\enforceVoiceCrossProhibition: true,
	));

	~r1 = Dictionary[
		\enforceChordPosition     -> false,
		\enforceRootPosition      -> true,
		\enforceFirstInversion    -> false,
		\enforceSecondInversion   -> false,
		\enforceThirdInversion    -> false,
		\enforceExtendedInversion -> false,
		\enforceUnisonProhibition -> true
	];

	~r2 = Dictionary[
		\enforceChordPosition     -> true,
		\enforceRootPosition      -> false,
		\enforceFirstInversion    -> false,
		\enforceSecondInversion   -> true,
		\enforceThirdInversion    -> false,
		\enforceExtendedInversion -> false,
		\enforceUnisonProhibition -> true
	];

	~prevC = MENoteRange.newFromName(
		"C#3", "G#3", "E4", "B4",
		degrees: [\P1, \P5, \m3, \m7]
	);
}
)

(
MEBacktrack.counter = 0;
~c0 = MEChord("Bm3P5m7", prevChord: ~p2);
"Number of chords generated: ".post;
~c0.chords.size.postln;
"Number of recursive calls:  ".post;
MEBacktrack.counter.postln;
)

(
MEBacktrack.counter = 0;
~c1 = MEChord("Bm3P5m7", ruleProf: ~r1);
~p1 = ~c1.chords.choose;

~c2 = MEChord("Em3P5m7", ~p1, ~r2);
~p2 = ~c2.chord;
~c1;
)

(
~routine = { |prevChord, chords|
	Routine {
		chords.asArray.scramble.reverseDo { |c, i|
			//"Chord#% ".format(i).padRight(4).post;

			prevChord.do { |n|
				"% ".format(n.name).padRight(6).post;
				Synth(\tone, [\freq, n.freq])
			};
			"".postln;
			1.wait;

			c.do{ |n|
				"% ".format(n.name).padRight(6).post;
				Synth(\tone, [\freq, n.freq, \amp, 0.5]);
				//0.25.wait;
			};
			"".postln;
			1.wait;
		};
	}.play;
};
~routine.(~p1, ~c2.chords);
)
