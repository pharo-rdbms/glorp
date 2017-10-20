types
serial

	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: (self integer typeString)].