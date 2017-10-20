types
timestamp
	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'timestamp without time zone'].