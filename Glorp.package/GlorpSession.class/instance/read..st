api/queries
read: aClass
	"Return an array of instances of aClass, each one from a row of its corresponding database table."

	^self execute: (SimpleQuery read: aClass)