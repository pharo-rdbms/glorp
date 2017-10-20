types
serial

	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: 'int AUTO_INCREMENT'].