conversion-strings
stringToInteger: aString for: aType
	| string |
	string := self unpadString: aString for: aType.
	^string isNil ifTrue: [nil] ifFalse: [string asNumber truncated].