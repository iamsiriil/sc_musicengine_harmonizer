MERules {
	classvar <rules;

	*initClass {

		rules = Dictionary[
			/*\enforceMelodicIntervals      -> true,
			\enforceVocalRange            -> true,
			\enforceCommonTones           -> false,
			\enforceParallelOctaves       -> true,
			\enforceParallelFifths        -> true,
			\enforceNoteDuplicate         -> false,
			\enforceRootDuplicate         -> false,
			\enforceThirdDuplicate        -> false,
			\enforceFifthDuplicate        -> false,*/
			\enforceVoiceCrossProhibition -> true,
			\enforceChordPosition         -> true,
			\enforceRootPosition          -> true,
			\enforceFirstInversion        -> false,
			\enforceSecondInversion       -> false,
			\enforceThirdInversion        -> false,
			\enforceExtendedInversion     -> false
			//\enforceUnisonProhibition     -> false
		];

		super.initClass;
	}

	*listRules {

		rules.keysValuesDo { |k, v|

			"% ".format(k).padRight(29).post;
			"%".format(v).postln;
		};
	}

	*changeRules { |newRules|

		newRules.keysValuesDo { |k, v|
			rules[k] = v;
		}
	}
}