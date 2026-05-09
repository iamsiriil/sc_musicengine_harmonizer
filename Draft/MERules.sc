MERules {
	classvar <userDefault;
	classvar <default;
	classvar <rules;

	*initClass {

		default = Dictionary[
			/*
			\enforceVocalRange            -> true,
			\enforceCommonTones           -> false,
			\enforceNoteDuplicate         -> false,
			\enforceRootDuplicate         -> false,
			\enforceThirdDuplicate        -> false,
			\enforceFifthDuplicate        -> false,*/
			\enforceMelodicIntervals      -> true,
			\enforceParallelOctaves       -> true,
			\enforceParallelFifths        -> true,
			\enforceVoiceCrossProhibition -> true,
			\enforceChordPosition         -> true,
			\enforceRootPosition          -> true,
			\enforceFirstInversion        -> false,
			\enforceSecondInversion       -> false,
			\enforceThirdInversion        -> false,
			\enforceExtendedInversion     -> false,
			\enforceUnisonProhibition     -> true
		];

		rules = default;

		super.initClass;
	}

	/****************************************************************************************/

	*listRules {

		if (userDefault.notNil) {
			userDefault.keysValuesDo { |k, v|

				"% ".format(k).padRight(29).post;
				"%".format(v).postln;
			};
		} {
			rules.keysValuesDo { |k, v|

				"% ".format(k).padRight(29).post;
				"%".format(v).postln;
			};
		};

	}

	/****************************************************************************************/

	*setRules { |ruleDict|
		var temp = default;
		
		ruleDict.keysValuesDo { |k, v|
			temp[k] = v;
		};

		userDefault = temp;

		rules = userDefault;
	}

	/****************************************************************************************/

	*resetRules {

		if (userDefault.notNil) {
			rules = userDefault;
		} {
			rules = default;
		}
	}
	
	/****************************************************************************************/

	*resetDefault {
		rules = default;
	}

	/****************************************************************************************/
	
	*toggleRules { |ruleDict|

		ruleDict.keysValuesDo { |k, v|
			rules[k] = [v];
		};
	}

	/****************************************************************************************/

	*rules_ { |ruleDict|
		rules = ruleDict;
	}

	/****************************************************************************************/

	*default_ {
		rules = default;
	}
}
