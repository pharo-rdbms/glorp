mapping
mapObject: anObject inElementBuilder: anElementBuilder
	| value |
	value := anElementBuilder isNil
		ifTrue: [constantValue]
		ifFalse: [self constantValueIn: anElementBuilder session].
	self setValueIn: anObject to: value