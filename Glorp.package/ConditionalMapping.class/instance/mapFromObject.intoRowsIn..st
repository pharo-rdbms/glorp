mapping
mapFromObject: anObject intoRowsIn: aRowMap 
	self canWrite ifFalse: [^self].
	(self applicableMappingForObject: anObject) 
		mapFromObject: anObject
		intoRowsIn: aRowMap.
	conditionalFieldMapping isNil ifTrue: [^self].
	conditionalFieldMapping 
		mapFromObject: (self conditionalValueFor: anObject)
		intoRowsIn: aRowMap