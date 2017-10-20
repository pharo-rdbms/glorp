testing
canUseGroupedWrites
	"We can use grouped writes as long as there are no identity columns in use"
	self platform usesIdentityColumns ifFalse: [^true].
	^(self allTables anySatisfy: [:each |
		each primaryKeyFields anySatisfy: [:eachField |
			eachField type isSerial and: [eachField type sequence isIdentityColumn]]]) not.