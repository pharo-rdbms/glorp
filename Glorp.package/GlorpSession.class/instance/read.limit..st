api/queries
read: aClass limit: anInteger
	"Return an array of not more than anInteger of instances of aClass, each one from a row of its corresponding database table."

	^self execute: (SimpleQuery read: aClass limit: anInteger)