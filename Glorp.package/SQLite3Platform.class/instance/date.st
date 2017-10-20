types
date
	"SQLite does not support any time-related types;  use text as the type and convert in readDate.../toDate..."

	^self typeNamed: #date ifAbsentPut: [GlorpDateType new typeString: 'date']