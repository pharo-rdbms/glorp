testing
mapsPrimaryKeys
	^(self mappedFields detect: [:each | each isPrimaryKey] ifNone: [nil]) notNil