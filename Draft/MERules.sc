MERules {
	classvar <userDefault;
	classvar <default;
	classvar <rules;

	*initClass {

		default = Dictionary[
		//	\enforceVocalRange            -> true,
		//	\enforceNoteDuplicate         -> false,
		//	\enforceRootDuplicate         -> false,
		//	\enforceThirdDuplicate        -> false,
		//	\enforceFifthDuplicate        -> false,
			\enforceCommonTones           -> false,
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

		rules = default.deepCopy;

		super.initClass;
	}

	/****************************************************************************************/

	*listRules {

		if (userDefault.notNil) {
			"User default:".postln;
			userDefault.keysValuesDo { |k, v|

				"% ".format(k).padRight(29).post;
				"%".format(v).postln;
			};
		} {
			"Default".postln;
			rules.keysValuesDo { |k, v|

				"% ".format(k).padRight(29).post;
				"%".format(v).postln;
			};
		};

	}

	/****************************************************************************************/

	*setRules { |ruleDict|
		var temp = default.deepCopy;

		//"setRules".postln;
		
		ruleDict.keysValuesDo { |k, v|
			temp[k] = v;
		};

		userDefault = temp;

		rules = userDefault;
	}

	/****************************************************************************************/

	*resetRules { rules = if (userDefault.notNil) { userDefault } { default } }
	
	/****************************************************************************************/

	*resetDefault { rules = default; userDefault = nil }

	/****************************************************************************************/
	
	*toggleRules { |ruleDict|

		//"toggleRules".postln;

		ruleDict.keysValuesDo { |k, v|
			rules[k] = v;
		};
	}
}
