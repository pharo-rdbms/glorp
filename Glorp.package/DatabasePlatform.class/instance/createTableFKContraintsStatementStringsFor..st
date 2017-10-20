obsolete
createTableFKContraintsStatementStringsFor: aGLORPDatabaseTable

	^aGLORPDatabaseTable foreignKeyConstraintsForCreation
		collect: [:each |	self createConstraintAddStatement: each ]