accessing
wrapperAt: aField

	^self wrapperAt: aField ifAbsent: [self error: 'Field not found'].