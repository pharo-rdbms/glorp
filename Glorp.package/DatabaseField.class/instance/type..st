configuring
type: aDatabaseType

	type := aDatabaseType.
	(type notNil and: [type isSerial]) ifTrue: [self bePrimaryKey].