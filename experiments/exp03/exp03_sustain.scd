/****************************************************************************************/
(
~sustainCommonTones = { |voice, dur, tempV, tempD, i|
	var size;

	case
	{ i == voice.size } {
		[tempV, tempD];
	}
	{ (i > 0) } {
		if (voice[i] != (voice[i - 1])) {
			tempV.add(voice[i].deepCopy);
			tempD.add(dur[i]);
			~sustainCommonTones.(voice, dur, tempV, tempD, i + 1);
		}{
			size = tempD.size;

			tempD[size - 1] = tempD[size - 1] + dur[i];
			~sustainCommonTones.(voice, dur, tempV, tempD, i + 1);
		}
	}
	{ i == 0} {
		tempV.add(voice[i].deepCopy);
		tempD.add(dur[i]);
		~sustainCommonTones.(voice, dur, tempV, tempD, i + 1);
	};
};

/****************************************************************************************/

~getVoices = { |prog, dur, numVoices|
	var voices = Array.new(numVoices);
	var tempV, tempD, temp;

	prog = prog.flop;

	prog.do { |v|
		tempV = Array.new(v.size);
		tempD = Array.new(v.size);
		temp = ~sustainCommonTones.(v, dur, tempV, tempD, 0);

		temp[0].do { |n, i|
			n.set(\dur, temp[1][i]);
		};

		voices.add(MENoteRange.with(nil, *temp[0]));
	};
	voices;
};
)
