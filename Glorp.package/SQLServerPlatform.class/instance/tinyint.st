types
tinyint
	^self typeNamed: #tinyInt ifAbsentPut: [GlorpIntegerType new typeString: 'tinyint'].