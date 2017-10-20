accessing
type
	| field |
	type isNil ifFalse: [^type].
	field := self field.
	^field isNil ifTrue: [self defaultType] ifFalse: [field type].