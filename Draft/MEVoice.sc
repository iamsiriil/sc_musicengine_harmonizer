MEVoice {
	classvar <range;
	classvar <validIntervals;
	classvar <voiceNumber = 4;
	classvar <voiceNames = #[\bas, \ten, \alt, \spn];

	*initClass {

		range = Dictionary[
			\bas -> [40, 62],
			\ten -> [48, 69],
			\alt -> [55, 76],
			\spn -> [61, 81]
		];

		validIntervals = Dictionary[
			\bas -> [0, 1, 2, 3, 4, 5, 6, 7],
			\ten -> [0, 1, 2, 3, 4, 5, 6, 7],
			\alt -> [0, 1, 2, 3, 4, 5, 6, 7],
			\apn -> [0, 1, 2, 3, 4, 5, 6, 7]
		];
	}

	*voiceNumber_ { |voiceNum|
		voiceNumber = voiceNum
	}
}