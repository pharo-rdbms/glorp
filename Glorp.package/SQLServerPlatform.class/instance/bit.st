types
bit
	^self typeNamed: #bit ifAbsentPut: [GlorpBooleanType new typeString: 'bit'].