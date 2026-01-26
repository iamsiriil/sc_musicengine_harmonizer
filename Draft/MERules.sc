MERules {
	classvar <default;

	*initClass {

		default = Dictionary[
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
			\enforceExtendedInversion     -> false
			//\enforceUnisonProhibition     -> false
		];

		super.initClass;
	}
}