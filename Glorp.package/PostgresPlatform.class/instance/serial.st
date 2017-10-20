types
serial
	"For postgresql, we use sequences, and explicitly get the values ourselves, so just tell the database that they're integers."
	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: 'integer'].