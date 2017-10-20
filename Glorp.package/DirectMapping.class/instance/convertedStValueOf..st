private
convertedStValueOf: dbValue 
	^(converter isNil)
		ifTrue: [dbValue]
		ifFalse: [converter convert: dbValue fromDatabaseRepresentationAs: self field type]