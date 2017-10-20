types
time
	"SQLite does not support any time-related types;  use text as the type and convert in readTime.../toTime..."

	^self typeNamed: #time ifAbsentPut: [GlorpTimeType new typeString: 'time']