types
date
	^self typeNamed: #date ifAbsentPut: [GlorpTimeStampType new typeString: 'date'].