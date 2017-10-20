accessing
name: aString
	name := aString copyFrom: 1 to: (aString size min: OraclePlatform new maximumLengthOfTableName).