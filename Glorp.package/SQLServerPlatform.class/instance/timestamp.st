types
timestamp
	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'datetime'].