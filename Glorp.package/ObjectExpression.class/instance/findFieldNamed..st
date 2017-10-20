fields
findFieldNamed: aString
	| fields |
	fields := OrderedCollection new: 1.
	self tables do: [:each |
		| field |
		field := each fieldNamed: aString ifAbsent: [nil].
		field isNil ifFalse: [fields add: field]].
	fields isEmpty ifTrue: [self error: 'No field named ', aString, ' in ', self printString].
	fields size > 1 ifTrue: [self error: 'Ambiguous field ', aString, ' in ', self printString].
	^fields at: 1.