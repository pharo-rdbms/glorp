constants
createTableStatementStringFor: aGLORPDatabaseTable
	^(super createTableStatementStringFor: aGLORPDatabaseTable), ' ENGINE=', self engine.