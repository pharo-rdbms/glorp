accessing
conditional
	conditional isNil ifTrue: [conditional := self newMapping: ConditionalMapping].
	^conditional.