caching
primaryKeyFrom: aDictionary
	"Construct a primary key from the given parameters."

	self prepare.
	(aDictionary
		anySatisfy:
			[:each | self session system shouldForeignKeyValueBeTreatedAsNull: each])
		ifTrue: [^#()].
	^self whereClause primaryKeyFromDictionary: aDictionary