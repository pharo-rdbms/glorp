accessing
basicFunctions
	functions isNil ifTrue: [functions := self createBasicFunctionsFor: nil].
	^functions.