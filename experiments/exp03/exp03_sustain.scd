/****************************************************************************************/
(
~sustainVoices = { |voice, dur, tempV, tempD, i|
	var size;

	case
	{ i == voice.size } {
		[tempV, tempD];
	}
	{ (i > 0) } {
		if (voice[i] != (voice[i - 1])) {
			tempV.add(voice[i].deepCopy);
			tempD.add(dur[i]);
			~sustainVoices.(voice, dur, tempV, tempD, i + 1);
		}{
			size = tempD.size;

			tempD[size - 1] = tempD[size - 1] + dur[i];
			~sustainVoices.(voice, dur, tempV, tempD, i + 1);
		}
	}
	{ i == 0} {
		tempV.add(voice[i].deepCopy);
		tempD.add(dur[i]);
		~sustainVoices.(voice, dur, tempV, tempD, i + 1);
	};
};

/****************************************************************************************/

~getVoices = { |prog, dur, numVoices|
	var voices    = Array.new(numVoices);
	var durations = Array.new(numVoices);
	var tempV, tempD, temp;

	prog = prog.flop;

	prog.do { |v|
		tempV = Array.new(v.size);
		tempD = Array.new(v.size);
		temp = ~sustainVoices.(v, dur, tempV, tempD, 0);
		voices.add(temp[0]);
		durations.add(temp[1]);
	};

	voices.do { |v, i|
		v.do { |n, j|
			n.set(\dur, durations[i][j]);
		};
	};

	voices.do { |v, i|
		voices[i] = MENoteRange.with(nil, *v);
	};	
	voices;
};
)
