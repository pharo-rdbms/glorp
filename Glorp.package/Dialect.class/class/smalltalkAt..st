class lookup
smalltalkAt: aName

	^ self smalltalkAt: aName ifAbsent: [self error: 'element not found']