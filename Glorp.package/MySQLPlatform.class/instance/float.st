types
float
	^self typeNamed: #float ifAbsentPut: [GlorpFloatType new typeString: 'float' ].