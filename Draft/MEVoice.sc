MEVoice {
	classvar <range;
	classvar <validIntervals = #[0, 1, 2, 3, 4, 5, 6, 7];
	classvar <voiceNumber = 4;
	classvar <voiceNames = #[\bas, \ten, \alt, \spn];

	*initClass {

		/*range = Dictionary[
			\bas -> [40, 62],
			\ten -> [48, 69],
			\alt -> [55, 76],
			\spn -> [61, 81]
		];*/
	}

	*voiceNumber_ { |voiceNum|

		switch(voiceNum)
		{ 4 } {
			voiceNumber = 4;
			voiceNames  = [\bas, \ten, \alt, \spn];
			range       = Dictionary[
				\bas -> [40, 62],
				\ten -> [48, 69],
				\alt -> [55, 76],
				\spn -> [61, 81]
			];
		}
		{ 5 } {
			voiceNumber = 5;
			voiceNames  = [\bas, \ten, \alt, \spn2, \spn1];
			range       = Dictionary[
				\bas  -> [40, 62],
				\ten  -> [48, 69],
				\alt  -> [55, 76],
				\spn2 -> [61, 81],
				\spn1 -> [61, 81]
			];
		}
		{ 6 } {
			voiceNumber = 6;
			voiceNames  = [\bas, \ten, \alt2, \alt1, \spn2, \spn1];
			range       = Dictionary[
				\bas   -> [40, 62],
				\ten   -> [48, 69],
				\alt2  -> [55, 76],
				\alt1  -> [55, 76],
				\spn2  -> [61, 81],
				\spn1  -> [61, 81]
			];
		}
		{ 7 } {
			voiceNumber = 7;
			voiceNames  = [\bas, \ten2, \ten1, \alt2, \alt1, \spn2, \spn1];
			range       = Dictionary[
				\bas   -> [40, 62],
				\ten2  -> [48, 69],
				\ten1  -> [48, 69],
				\alt2  -> [55, 76],
				\alt1  -> [55, 76],
				\spn2  -> [61, 81],
				\spn1  -> [61, 81]
			];
		}
	}
}