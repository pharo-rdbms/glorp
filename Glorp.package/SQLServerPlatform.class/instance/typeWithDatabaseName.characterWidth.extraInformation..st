types
typeWithDatabaseName: aString characterWidth: aNumber extraInformation: extraValue
	"Return our type which matches the database name for the type. Assumes all variable width fields are strings right now."
	extraValue = 'IDENTITY' ifTrue: [^self serial].
	^super typeWithDatabaseName: aString characterWidth: aNumber.