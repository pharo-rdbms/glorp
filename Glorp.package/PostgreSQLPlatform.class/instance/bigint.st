types
bigint
	^self typeNamed: #bigint ifAbsentPut: [GlorpIntegerType new typeString: 'bigint'].