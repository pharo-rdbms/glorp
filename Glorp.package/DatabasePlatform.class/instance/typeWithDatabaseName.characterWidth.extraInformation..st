types
typeWithDatabaseName: aString characterWidth: aNumber extraInformation: anythingElse
	"Return our type which matches the database name for the type. Assumes all variable width fields are strings right now."
	^self typeWithDatabaseName: aString characterWidth: aNumber.