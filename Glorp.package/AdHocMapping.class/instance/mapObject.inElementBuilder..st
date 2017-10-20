public
mapObject: anObject inElementBuilder: anElementBuilder

	| readBlock row |
	row := anElementBuilder row.
	readBlock := [fromDbMappingBlock value: row value: anElementBuilder value: BaseExpression new].
	self shouldProxy 
		ifTrue: [self setValueIn: anObject to: (AdHocProxy readBlock: readBlock)]
		ifFalse: [self setValueIn: anObject to: readBlock value]