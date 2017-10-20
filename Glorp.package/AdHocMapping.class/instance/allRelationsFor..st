printing SQL
allRelationsFor: rootExpression
	"We may have multiple relationships."
	| tables rows result rightChild rightHandSide |
	tables := self mappedTables.
	rows := Dictionary new.
	tables do: [:each | rows at: each put: (DatabaseRow newForTable: each)].
	rightChild := rootExpression rightChild.
	rightHandSide := rightChild isConstantExpression ifTrue: [rightChild value] ifFalse: [rightChild].
	toDbMappingBlock value: rows value: rightHandSide value: Dictionary new. 
	result := nil.
	rows do: [:eachRow |
		| table |
		table := rootExpression leftChild base getTable: eachRow table.
		eachRow fieldsAndValidValuesDo: [:eachField :eachValue |  | newExp |
			newExp := (table getField: eachField) get: rootExpression relation withArguments: (Array with: eachValue).
			result := newExp AND: result.]].
	^result.