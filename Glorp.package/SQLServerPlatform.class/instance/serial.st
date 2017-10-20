types
serial

	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: 'int  IDENTITY (1, 1) '].