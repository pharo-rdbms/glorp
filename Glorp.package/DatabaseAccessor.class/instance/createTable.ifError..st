executing
createTable: aGlorpDatabaseTable ifError: aBlock 
	"This method should be used to create a database table from aTable"
	aGlorpDatabaseTable isImaginary ifTrue: [^self].
	self
		executeInDDLOperation: [
			self executeSQLStringNoResult: (self platform createTableStatementStringFor: aGlorpDatabaseTable)]
		ifError: aBlock