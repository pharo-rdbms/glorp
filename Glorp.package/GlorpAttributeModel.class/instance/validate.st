validation
validate
	name isEmpty ifTrue: [self error: 'Invalid attribute name']