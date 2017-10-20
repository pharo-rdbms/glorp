accessing
printSQL
	self nextPutAll: 'DELETE FROM '.
	row table printSQLOn: self withParameters: #().
	self nextPutAll: ' WHERE '.
	row printPrimaryKeyTemplateOn: self.