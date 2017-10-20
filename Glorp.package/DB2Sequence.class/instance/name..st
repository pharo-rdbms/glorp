accessing
name: aString
	name := aString copyFrom: 1 to: (aString size min: DB2Platform new maximumLengthOfTableName).