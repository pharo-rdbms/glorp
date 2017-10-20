executing
dropTableNamed: aString ifAbsent: aBlock 
	self doDDLOperation: [
		self 
			execute: [self executeSQLStringNoResult: (self platform createDropTableStatementFor: aString )]
			ifError: aBlock].