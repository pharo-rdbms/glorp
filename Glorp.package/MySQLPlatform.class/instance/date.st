types
date
	"Return the type we use to represent dates."
	^self typeNamed: #date ifAbsentPut: [GlorpDateType new].