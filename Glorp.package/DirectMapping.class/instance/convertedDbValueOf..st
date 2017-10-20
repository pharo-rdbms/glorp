private
convertedDbValueOf: stValue 
	^converter isNil
		ifTrue: [stValue]
		ifFalse: [converter convert: stValue toDatabaseRepresentationAs: self field type]