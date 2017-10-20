conversion-strings
toGlorpType: aGlorpType fromString: aString
	"Return a Smalltalk instance of the type indicated by aGlorpType."
	
	| aClass |
	^aString
		ifNotNil:
			[aClass := aGlorpType impliedSmalltalkType.
			aClass readFrom: aString readStream]