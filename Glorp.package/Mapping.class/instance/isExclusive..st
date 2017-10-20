api
isExclusive: aBoolean
	aBoolean ifTrue: [self error: 'Only relationship mappings can be exclusive'].