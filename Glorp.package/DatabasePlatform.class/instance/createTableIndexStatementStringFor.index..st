services tables
createTableIndexStatementStringFor: aGLORPDatabaseTable index: aGlorpDatabaseIndex

	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream nextPutAll: 'CREATE INDEX '.
	sqlStatementStream nextPutAll: aGlorpDatabaseIndex name.
	sqlStatementStream nextPutAll: ' ON '.
	self printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream.
	aGlorpDatabaseIndex printStatementOn: sqlStatementStream platform: self.
	^sqlStatementStream contents