services tables
tableNameFor: aStringRepresentingATableName
	"Return the table name, as modified to be used in a database statement."
	
	^(aStringRepresentingATableName
		detect: [:each | each isUppercase]
		ifNone: [nil]) isNil
	ifTrue: [aStringRepresentingATableName]
	ifFalse: ['"' , aStringRepresentingATableName , '"'].