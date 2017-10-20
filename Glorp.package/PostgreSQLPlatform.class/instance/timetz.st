types
timetz
	^self typeNamed: #timetz ifAbsentPut: [GlorpPGTimeWithTimeZoneType new].