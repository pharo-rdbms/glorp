types
double
	^self typeNamed: #double ifAbsentPut: [GlorpDoubleType new typeString: 'double' ].