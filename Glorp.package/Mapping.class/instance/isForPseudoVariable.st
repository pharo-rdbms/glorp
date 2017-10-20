accessing
isForPseudoVariable
	^self attribute isForPseudoVariable or: [self attributeAccessor isValid not]