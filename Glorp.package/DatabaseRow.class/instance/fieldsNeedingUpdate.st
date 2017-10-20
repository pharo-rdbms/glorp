printing
fieldsNeedingUpdate
	"Return a list of the fields that are different from the previous version (if we know what that was)"

	| result |
	oldVersion isNil ifTrue: [^self nonPrimaryKeyFields].
	result := OrderedCollection new: contents size.
	self fieldsDo: 
			[:each | 
			each isPrimaryKey 
				ifFalse: 
					[(oldVersion at: each ifAbsent: [self class missingFieldIndicator]) 
						= (self at: each) ifFalse: [result add: each]]].
	^result