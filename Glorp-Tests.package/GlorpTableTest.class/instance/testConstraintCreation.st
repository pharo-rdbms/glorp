tests
testConstraintCreation
	| constraint dropWord |
	constraint := ForeignKeyConstraint
		sourceField: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'BANK_CODE')
		targetField: ((system tableNamed: 'PERSON') fieldNamed: 'ID').
	self assert: constraint creationString =
		( 'CONSTRAINT ', constraint name, ' FOREIGN KEY (BANK_CODE) REFERENCES PERSON (ID)').
	dropWord := self keywordForConstraintsWhenDropping: constraint onPlatform: dbPlatform.	
	dbPlatform supportsAlterTableForConstraints ifTrue:
		[self assert: constraint dropString =
			( 'ALTER TABLE BANK_ACCT DROP ', dropWord, ' ', constraint name)].
	constraint := ForeignKeyConstraint
		sourceField: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'BANK_CODE')
		targetField: ((system tableNamed: 'PERSON') fieldNamed: 'ID')
		suffixExpression: 'ON DELETE CASCADE'.
	self assert: constraint creationString = ('CONSTRAINT ', constraint name, ' FOREIGN KEY (BANK_CODE) REFERENCES PERSON (ID) ON DELETE CASCADE').
	dbPlatform supportsAlterTableForConstraints ifTrue:
		[self assert: constraint dropString = ('ALTER TABLE BANK_ACCT DROP ', dropWord, ' ',  constraint name)].