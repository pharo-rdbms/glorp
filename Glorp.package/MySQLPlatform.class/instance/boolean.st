types
boolean
	^self typeNamed: #boolean ifAbsentPut: [GlorpBooleanType new typeString: 'boolean'].