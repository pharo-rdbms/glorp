conversion-strings
padTrimmedString: aString for: aType
	| padding trimmed |
	aString isNil ifTrue: [^nil].
	aString isString ifFalse: [self error: 'Invalid data type'].
	(self usesNullForEmptyStrings and: [aString isEmpty]) ifTrue: [^nil].
	trimmed := self trimString: aString for: aType.
				
	(aType isVariableWidth or: [trimmed size = aType width]) ifTrue: [^trimmed].
	padding := String new: aType width - aString size.
	padding atAllPut: self paddingCharacter.
	^aString , padding