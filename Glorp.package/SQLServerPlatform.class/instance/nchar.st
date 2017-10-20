types
nchar
	^self typeNamed: #nchar ifAbsentPut: [GlorpCharType new typeString: 'nchar']