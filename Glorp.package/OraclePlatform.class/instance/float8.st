types
float8
	^self typeNamed: #float8 ifAbsentPut: [GlorpDoubleType new typeString: 'double precision'].