accessing
at: aField

	^self at: aField ifAbsent: [self error: 'missing field'].