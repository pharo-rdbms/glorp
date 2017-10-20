tests
testConstraintNonCreation

	| constraint |
	constraint := ForeignKeyConstraint 
		sourceField: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'BANK_CODE')
		targetField: ((system tableNamed: 'PERSON') fieldNamed: 'ID').
	constraint shouldCreateInDatabase: false.
	self assert: constraint creationString = ''.
	self assert: constraint dropString = ''.