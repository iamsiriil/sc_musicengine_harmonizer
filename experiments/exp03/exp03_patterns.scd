/****************************************************************************************/
(
~melody = { |melody|
	Pbind(
		\instrument, \default,
		\midinote, melody.asPseq(\midi),
		\dur, melody.asPseq(\dur),
		\amp, 0.2,
		\tmp, melody.asPseq(\tmp),
		\tempoChange, Pfunc { |ev| if (ev[\tmp] > 0) { ~clock.tempo = ev[\tmp] }; 0 },
		\name, Pseq(melody.names),
		\printName, Pfunc { |ev| ev[\name].postln }
	)
};

/****************************************************************************************/

~bass = { |bass|
	Pbind(
		\instrument, \default,
		\midinote, bass.asPseq(\midi),
		\dur, bass.asPseq(\dur),
		\amp, 0.3,
	)
};

/****************************************************************************************/

~counterpoint = { |voices|
	Ppar([
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((voices[0] >> 12).midi),
			\dur, voices[0].asPseq(\dur),
			\legato, 0.99,
			\amp, 0.1
		),
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((voices[1] >> 12).midi),
			\dur, voices[1].asPseq(\dur),
			\legato, 0.99,
			\amp, 0.08
		),
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((voices[2] >> 12).midi),
			\dur, voices[2].asPseq(\dur),
			\legato, 0.99,
			\amp, 0.07
		),
		Pbind(
			\instrument, \sin,
			\midinote, Pseq((voices[3] >> 12).midi),
			\dur, voices[3].asPseq(\dur),
			\legato, 0.99,
			\amp, 0.06
		)
	])
};

/****************************************************************************************/

~spawner = { |melody, bass, voices1, voices2|
	Pspawner({ |sp|
		sp.par(~melody.value(melody));

		sp.wait(1);
		sp.par(~bass.value(bass));
		sp.seq(~counterpoint.value(voices1));

		sp.wait(3);
		sp.seq(~counterpoint.value(voices2));
	});
};
)
