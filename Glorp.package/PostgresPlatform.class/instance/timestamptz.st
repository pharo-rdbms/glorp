types
timestamptz
	^self typeNamed: #timestamptz ifAbsentPut: [GlorpPGTimestampWithTimeZoneType new]