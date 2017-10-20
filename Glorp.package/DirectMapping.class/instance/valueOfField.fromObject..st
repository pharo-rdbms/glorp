mapping
valueOfField: aField fromObject: anObject
	field = aField ifFalse: [self error: 'Mapping doesn''t describe field'].
	^self convertedDbValueOf: (self getValueFrom: anObject)