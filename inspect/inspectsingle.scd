/****************************************************************************************/
// Single chord realization
s.boot;
/****************************************************************************************/
// Simple four part chord realization over the F#min triad
// given the default set of rules.
(
~c = MEChord("F#min", voiceNum: 4);

// .chord == to first chord in sequence
~c.chords[0] == ~c.chord;

// Total number of realizations given the default rule profile
~c.chords.size.postln;
)
// Playing different realizations
Pbind(\midinote, Pseq((~c.chords[3] >> 12).midi)).play;

/****************************************************************************************/
// Five part realizations of a F#min triad,
// given the default set of rules
(
~c1 = MEChord("F#min", voiceNum: 6);

// Total number of realizations given the default rule profile
~c1.chords.size.postln;
)
// Playing different realizations
Pbind(\midinote, Pseq((~c1.chords[10] >> 12).midi)).play;

/****************************************************************************************/
// Six part realizations of a F#min triad,
// given a prescribed set of rules.
(
// Set the rules
~r2 = Dictionary[
	\enforceParallelOctaves   -> true,
	\enforceParallelFifths    -> true,
	\enforceChordPosition     -> true,
	\enforceRootPosition      -> false,
	\enforceFirstInversion    -> true,
	\enforceSecondInversion   -> false,
	\enforceThirdInversion    -> false,
	\enforceExtendedInversion -> false,
	\enforceUnisonProhibition -> true
];

~c2 = MEChord("E-^7", ruleProf: ~r2, voiceNum: 5);

// Total number of realizations given the default rule profile
~c2.chords.size.postln;
)
// Playing different realizations
Pbind(\midinote, Pseq((~c2.chords[12] >> 24).midi)).play; // Use transposition operators on MENoteRange objs

