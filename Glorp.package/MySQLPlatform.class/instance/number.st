types
number

	^self typeNamed: #number ifAbsentPut: [GlorpNumericType new typeString: 'decimal'].