types
nvarchar
	^self typeNamed: #nvarchar ifAbsentPut: [GlorpVarCharType new typeString: 'nvarchar'].