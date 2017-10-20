accessing
field
	field isNil ifTrue: [field := table primaryKeyFields first].
	^field.