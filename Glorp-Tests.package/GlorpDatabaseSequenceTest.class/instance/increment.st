tests
increment
	"If the platform>>supportsSettingSequenceIncrement, then this test should ask for the increment from the sequence object itself.  Otherwise, it is the default, 1."

	^system platform supportsSettingSequenceIncrement
		ifTrue: [sequence sequenceIncrement]
		ifFalse: [1]