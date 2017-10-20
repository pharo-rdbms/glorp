indexes
hasIndexForField: aField
	^(indexes detect: [:each | each indexesField: aField] ifNone: [nil]) notNil.