accessing
mappingExpressions
	mappingExpressions isNil ifTrue: [mappingExpressions := IdentityDictionary new].
	^mappingExpressions.