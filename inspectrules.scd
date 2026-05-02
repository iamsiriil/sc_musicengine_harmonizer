/****************************************************************************************/
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

	// Change default rules
	MERules.changeRules((
		enforceChordPosition:     true,
		enforceRootPosition:      true,
		enforceFirstInversion:    false,
		enforceSecondInversion:   false,
		enforceThirdInversion:    false,
		enforceExtendedInversion: false,
		enforceUnisonProhibition: true

		//\enforceVoiceCrossProhibition: true,
	));

	// Dummy rule profile 1
	~r1 = Dictionary[
		\enforceChordPosition     -> false,
		\enforceRootPosition      -> true,
		\enforceFirstInversion    -> false,
		\enforceSecondInversion   -> false,
		\enforceThirdInversion    -> false,
		\enforceExtendedInversion -> false,
		\enforceUnisonProhibition -> true
	];

	// Dummy rule profile 2
	~r2 = Dictionary[
		\enforceChordPosition     -> true,
		\enforceRootPosition      -> false,
		\enforceFirstInversion    -> false,
		\enforceSecondInversion   -> true,
		\enforceThirdInversion    -> false,
		\enforceExtendedInversion -> false,
		\enforceUnisonProhibition -> true
	];

	// Previous chord as MENoteRange
	~prevC = MENoteRange.newFromName(
		"C#3", "G#3", "E4", "B4",
		degrees: [\P1, \P5, \m3, \m7]
	);
}
)

/****************************************************************************************/
// Monitor number of backtrack calls
(
MEBacktrack.counter = 0;
~c0 = MEChord("Bm3P5m7M9", prevChord: ~p2, voiceNum: 7);
"Number of chords generated: ".post;
~c0.chords.size.postln;
"Number of recursive calls:  ".post;
MEBacktrack.counter.postln;
)

/****************************************************************************************/
// Simple two chord alternation
(
MEBacktrack.counter = 0;
// Create chord A
~c1 = MEChord("Bm3P5m7", ruleProf: ~r1).chords.choose.postln;
// Create chord B from chord A
~c2 = MEChord("Em3P5m7", ~c1, ~r2).chords.postln;
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
~routine.(~c1, ~c2);
)
