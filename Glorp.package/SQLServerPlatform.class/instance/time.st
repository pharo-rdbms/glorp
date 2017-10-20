types
time
	^self typeNamed: #time ifAbsentPut: [GlorpTimeType new typeString: 'datetime'].