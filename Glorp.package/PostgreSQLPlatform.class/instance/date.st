types
date
	^self typeNamed: #date ifAbsentPut: [GlorpDateType new typeString: 'date'].