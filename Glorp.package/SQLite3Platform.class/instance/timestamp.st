types
timestamp
	"SQLite does not support any time-related types;  use text as the type and convert in readTimestamp.../toTimestamp..."

	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'timestamp']