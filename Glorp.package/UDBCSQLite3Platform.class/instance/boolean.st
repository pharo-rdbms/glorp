types
boolean
	"Booleans are represented as integers within the database, but converted to Booleans by the driver"

	^self typeNamed: #boolean ifAbsentPut: [GlorpBooleanType new typeString: 'boolean'].