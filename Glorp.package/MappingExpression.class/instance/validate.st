preparing
validate
	self mappingFromMeOrSubclasses isNil ifTrue: [self error: 'no mapping for ', self printString].