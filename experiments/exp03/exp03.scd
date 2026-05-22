/****************************************************************************************/
(
s.waitForBoot({
	"./exp03_resources.scd".loadRelative;
	"./exp03_sustain.scd".loadRelative;
	"./exp03_patterns.scd".loadRelative;
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

"\nProgression #1 [".postln;
~chords1.do { |c| c.postln };
"]".postln;

"\nProgression #2 [".postln;
~chords2.do { |c| c.postln };
"]".postln;

// Play Pspawner
~clock = TempoClock.new(50/60);
~spawner.(~m, ~b, ~voices1, ~voices2).play(~clock);
)
