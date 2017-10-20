accessing
printSQL
	stream nextPutAll: 'SELECT '.
	query printSelectFieldsOn: self.
	self findBoundExpressions.
	query printTablesOn: self.
	query printWhereClauseOn: self.
	query printJoinsOn: self.
	query printGroupingOn: self.
	query printOrderingOn: self.
	query printPostLimitOn: self.
	query printOffsetOn: self.