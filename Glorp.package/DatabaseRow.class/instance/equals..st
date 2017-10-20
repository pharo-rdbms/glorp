testing
equals: aRow 
	self forDeletion = aRow forDeletion ifFalse: [^false].
	self fieldsAndValuesDo: 
			[:eachField :eachWrapper | 
			| otherValue |
			otherValue := aRow at: eachField ifAbsent: [self class missingFieldIndicator].
			eachWrapper = otherValue ifFalse: [^false]].
	^true