primary keys
primaryKeyFromDictionary: aDictionary
	"Given a set of parameters, return a primary key suitable for retrieving our target. Return either a value for the key, nil for no key found, or an array for compound keys."
	
	sources size = 1 ifTrue: [^aDictionary at: sources first ifAbsent: [nil]].
	^sources collect: [:each | aDictionary at: each ifAbsent: [nil]].