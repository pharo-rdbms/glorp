constants
engine
	engine ifNil: [ self beInnoDB ].
	^engine