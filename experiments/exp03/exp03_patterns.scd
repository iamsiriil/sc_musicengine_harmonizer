/****************************************************************************************/
// EXPERIMENT 03 : Chopin, Prelude in E minor - Patterns
/****************************************************************************************/
(
~melody = { |melody, mSynth|
	Pbind(
		\instrument, mSynth,
		\freq, Pseq(melody.freq / 2),
		\dur, melody.asPseq(\dur),
		\legato, melody.asPseq(\lgt),
		\amp, melody.asPseq(\amp),
		\atk, melody.asPseq(\atk),
		\mRatio, 0.5,
		\cRatio, 1,
		\pan, -0.4,
		\out, 4,
		\tmp, melody.asPseq(\tmp),
		\tempoChange, Pfunc { |ev| if (ev[\tmp] > 0) { ~clock.tempo = ev[\tmp] }; 0 },
		\name, Pseq(melody.names),
		\printName, Pfunc { |ev| ev[\name].postln }
	)
};

/****************************************************************************************/

~bass = { |bass, bSynth|
	Pbind(
		\instrument, bSynth,
		\midinote, bass.asPseq(\midi),
		\dur, bass.asPseq(\dur),
		\legato, 0.6,
		\atk, 0.01,
		\amp, 0.3,
		\pan, -0.7,
		\out, 6
	)
};

/****************************************************************************************/

~counterpoint = { |voices, cSynth|
	Ppar([
		Pbind(
			\instrument, cSynth,
			\freq, Pseq(voices[0].freq * 2),
			\dur, voices[0].asPseq(\dur),
			\legato, 0.99,
			\mRatio, 4,
			\cRatio, 3,
			\atk, 0.4,
			\amp, 0.4,
			\pan, -0.6,
			\out, 8,
		),
		Pbind(
			\instrument, cSynth,
			\freq, Pseq(voices[1].freq * 2),
			\dur, voices[1].asPseq(\dur),
			\legato, 0.99,
			\mRatio, 4,
			\cRatio, 3,
			\atk, 0.4,
			\amp, 0.3,
			\pan, 0.2,
			\out, 10,
		),
		Pbind(
			\instrument, cSynth,
			\freq, Pseq(voices[2].freq * 2),
			\dur, voices[2].asPseq(\dur),
			\legato, 0.99,
			\mRatio, 4,
			\cRatio, 3,
			\atk, 0.4,
			\amp, 0.2,
			\pan, 0.2,
			\out, 12,
		),
		Pbind(
			\instrument, cSynth,
			\freq, Pseq(voices[3].freq * 2),
			\dur, voices[3].asPseq(\dur),
			\legato, 0.99,
			\mRatio, 4,
			\cRatio, 3,
			\atk, 0.4,
			\amp, 0.2,
			\pan, 0.6,
			\out, 14,
		)
	])
};

/****************************************************************************************/

~spawner = { |melody, bass, voices1, voices2, mSynth, bSynth, cSynth|
	Pspawner({ |sp|
		sp.par(~melody.value(melody, mSynth));

		sp.wait(1);
		sp.par(
			Pbind(
				\instrument, \kick,
				\dur, Pseq([3/4, 1/4, Rest(1), 3/4, 1/4, Rest(1)], inf),
				\amp, 1.0, //Pseq([0.9, 0.7, Rest(1), 0.8, 0.6, Rest(1)], inf),
				\freq, 28.midicps,
				\out, 16,
				\pan, -8
			)
		);
		sp.par(
			Pbind(
				\instrument, \snare,
				\dur, Pseq([Rest(1), 1, Rest(1), 1], inf),
				\freq, 28.midicps,
				\amp, 0.9,
				\out, 18,
				\pan, -7
			)
		);
		sp.par(~bass.value(bass, bSynth));
		sp.seq(~counterpoint.value(voices1, cSynth));

		sp.wait(3);
		sp.seq(~counterpoint.value(voices2, cSynth));
	});
};
)
