accessing
arrayBoundFields
	"For array binding, include all the fields, except if we're inserting into a database with identity columns, where we must omit those columns"
	^self platform usesIdentityColumns
		ifTrue: [row table fields reject: [:each | each type isIdentityColumn]]
		ifFalse: [row table fields].