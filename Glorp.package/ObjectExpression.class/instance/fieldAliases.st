accessing
fieldAliases

	fieldAliases isNil ifTrue: [fieldAliases := IdentityDictionary new].
	^fieldAliases.