conversion-strings
padString: aString for: aType
	"Between 0.3.140.1 and 7.10 inclusive, Glorp trimmed strings that were too long for fixed-length fields.  This is no longer done, so such strings (sometimes too long only because the database platform measuresStringFieldWidthsInBytes and the string has multi-byte characters) will normally cause database errors (intentionally:  overlong strings should not be submitted to such fields)."

	| padding |
	aString isNil ifTrue: [^nil].
	aString isString ifFalse: [self error: 'Invalid data type'].
	(self usesNullForEmptyStrings and: [aString isEmpty]) ifTrue: [^nil].
	(aType isVariableWidth or: [aString size >= aType width]) ifTrue: [^aString].
	padding := String new: aType width - aString size.
	padding atAllPut: self paddingCharacter.
	^aString , padding