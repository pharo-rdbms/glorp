conversion-strings
stringToByteArray: aString for: aType
	| string |
	string := self unpadString: aString for: aType.
	^string isNil ifTrue: [nil] ifFalse: [Dialect convert: string toByteArrayWithEncoding: self characterEncoding].