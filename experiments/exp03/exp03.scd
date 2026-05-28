/****************************************************************************************/
// EXPERIMENT 03 : Chopin, Prelude in E minor - Player
/****************************************************************************************/
(
s.waitForBoot({
	"./exp03_resources.scd".loadRelative;
	"./exp03_patterns.scd".loadRelative;
	"./exp03_synths.scd".loadRelative;
	"./exp03_utils.scd".loadRelative;
});
)
/****************************************************************************************/
(
~v = 4; // Four voices

// Fisrt section
~chords1 = ~getChords.(~p1,  ~v);          // Harmonize progression
~voices1 = ~getVoices.(~chords1, ~d1, ~v); // Return voices with sustained common tones

// Second section
~chords2 = ~getChords.(~p2, ~v);
~voices2 = ~getVoices.(~chords2, ~d2, ~v);

// Post progressions
"\nProgression #1 [".postln;
~chords1.do { |c| c.postln };
"]".postln;

"\nProgression #2 [".postln;
~chords2.do { |c| c.postln };
"]".postln;

/****************************************************************************************/
// Play piece

// Set clock
~clock = TempoClock.new(50/60);

// Start reverb and mixer
Synth(\rev, [\in, 30, \out, 0, \revamp, 0.9]);
Synth(\mix, [\out, 30, \amp, 0.9]);

// Play Pspawner
~spawner.(~m, ~b, ~voices1, ~voices2, \solo, \bass,\fm).play(~clock);
)