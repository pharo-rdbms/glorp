types
boolean
	^self typeNamed: #boolean ifAbsentPut: [GlorpMySQLBooleanType new typeString: 'boolean'].