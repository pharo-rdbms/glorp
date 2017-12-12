mapping
expressionFor: anObject basedOn: anExpression relation: aSymbol
	"Return our expression using the object's values. e.g. if this was a direct mapping from id->ID and the object had id: 3, then return TABLE.ID=3"

	| value |
	value := anObject isNil
		ifTrue: [nil]
		ifFalse:
			[anObject isGlorpExpression
				ifTrue: [anObject getMapping: self named: self attributeName]
				ifFalse: [anObject glorpIsCollection
					ifTrue: [anObject collect: [:each | self convertedDbValueOf: (attribute getValueFrom: each)]]
					ifFalse: [self convertedDbValueOf: (attribute getValueFrom: anObject)]]].
	^(anExpression get: self attribute name) get: aSymbol withArguments: (Array with: value)