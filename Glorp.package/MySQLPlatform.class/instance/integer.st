types
integer

	^self typeNamed: #integer ifAbsentPut: [GlorpIntegerType new typeString: 'int'].