
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
	enforceChordPosition:         true,
	enforceRootPosition:          false,
	enforceFirstInversion:        true,
	enforceSecondInversion:       false,
	enforceThirdInversion:        false,
	enforceExtendedInversion:     false,
	enforceUnisonProhibition:     true

	//\enforceVoiceCrossProhibition: true,
));
)

MEVoice.voiceNumber

// Only four to seven voices allowed.
// Number of voices must be greater or equal to
// number on degrees present in the range.
(
~prevC = MENoteRange.newFromName(
	"C#3", "G#3", "E4", "B4",
	degrees: [\P1, \P5, \m3, \m7]
);
(
MEBacktrack.counter = 0;
~c1 = MEChord("Bm3P4m7", nil, voiceNum: 4);
~p1 = ~c1.chord;

~c2 = MEChord("F#m3P4m7", ~p1, voiceNum: 4);
~p2 = ~c2.chord;
~c1.chords;
)
// 7th chord, four degrees (P1, m3, P5, m7); five voices.
)

~prevC[0].midi


(
MEBacktrack.counter = 0;
~c0 = MEChord("Bm3P4m7", ~p2, voiceNum: 4);
"Number of chords generated: ".post;
~c0.chords.size.postln;
"Number of recursive calls:  ".post;
MEBacktrack.counter.postln;
)
~c.chord
s.boot
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
~c.chordSet.asArray.scramble
~r = MEChordRange00("F#-7")
MESession.chordData['F#M3P4m6m9'].select { |n| (n.midi > 40) && (n.midi < 80) }

~c.chords

MESession.chordData['F#M3P4m6m9']