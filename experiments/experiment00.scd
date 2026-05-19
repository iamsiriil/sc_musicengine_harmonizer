/****************************************************************************************/
s.boot;
/****************************************************************************************/
(
SynthDef(\tone, {
	arg freq=440, amp=0.3;
	var env = EnvGen.kr(
		Env.new(
			[0, 1, 0],
			[0.01, 1],
			[4 -4]
		),
		doneAction: 2
	);
	var sig = Pulse.ar(freq) * env * amp;
	sig = Pan2.ar(sig, 0);
	Out.ar(0, sig);
}).add;

~p = ["C-", "F-", "F#o", "G", "C-", "DbNap", "C-", "GP4P5m7", "G7", "Cs4", "Cm3P5"];

~r0 = Dictionary[
	\enforceChordPosition     -> true,
	\enforceRootPosition      -> true,
	\enforceFirstInversion    -> false,
	\enforceSecondInversion   -> false,
	\enforceThirdInversion    -> false,
	\enforceExtendedInversion -> false,

];

~r1 = Dictionary[
	\enforceChordPosition     -> true,
	\enforceRootPosition      -> false,
	\enforceFirstInversion    -> true,
	\enforceSecondInversion   -> false,
	\enforceThirdInversion    -> false,
	\enforceExtendedInversion -> false,

];

~r2 = Dictionary[
	\enforceChordPosition     -> true,
	\enforceRootPosition      -> false,
	\enforceFirstInversion    -> false,
	\enforceSecondInversion   -> true,
	\enforceThirdInversion    -> false,
	\enforceExtendedInversion -> false,

];

~r3 = Dictionary[
	\enforceChordPosition     -> true,
	\enforceRootPosition      -> true,
	\enforceFirstInversion    -> false,
	\enforceSecondInversion   -> false,
	\enforceThirdInversion    -> false,
	\enforceExtendedInversion -> false,

];

~r4 = Dictionary[
	\enforceChordPosition     -> true,
	\enforceRootPosition      -> true,
	\enforceFirstInversion    -> false,
	\enforceSecondInversion   -> false,
	\enforceThirdInversion    -> false,
	\enforceExtendedInversion -> false,

];

~r5 = Dictionary[
	\enforceChordPosition     -> true,
	\enforceRootPosition      -> false,
	\enforceFirstInversion    -> false,
	\enforceSecondInversion   -> true,
	\enforceThirdInversion    -> false,
	\enforceExtendedInversion -> false,

];

~r6 = Dictionary[
	\enforceChordPosition     -> true,
	\enforceRootPosition      -> true,
	\enforceFirstInversion    -> false,
	\enforceSecondInversion   -> false,
	\enforceThirdInversion    -> false,
	\enforceExtendedInversion -> false,
];

~rls = [~r0, nil, nil, nil, nil, ~r1, ~r2, ~r3, ~r4, ~r5, ~r6];
)

/****************************************************************************************/
(
MERules.resetDefault;
~v = 4;

~prg = Array.new(~p.size);

~p.do { |s, i|
	var temp;
	if (i == 0) {
		temp = MEChord(s, ruleProf: ~rls[i], voiceNum: ~v).chords.choose;
		~prg.add(temp);
	} {
		temp = MEChord(s, prevChord: ~prg[i - 1], ruleProf: ~rls[i], voiceNum: ~v).chords[0];
		~prg.add(temp);
	}
};

~prg.do { |c| c.postln };
)

/****************************************************************************************/
(
Routine({

	~prg.do { |c|

		c.postln;
		c.do { |n|
			Synth(\tone, [\freq, n.freq]);
		};
		1.wait;
	}
}).play
)
