types
timestamp
	"Although MySQL has a type called 'timestamp', 'datetime' is more suitable."
	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'DATETIME'].