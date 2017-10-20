accessing
tableAliases
	tableAliases isNil ifTrue: [
		tableAliases := IdentityDictionary new: 3].
	^tableAliases