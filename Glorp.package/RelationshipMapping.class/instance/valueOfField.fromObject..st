mapping
valueOfField: aField fromObject: anObject
	^self valueOfField: aField fromObject: anObject ifNone: [self error: 'Cannot find value'].