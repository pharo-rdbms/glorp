accessing
printSQL
	stream nextPutAll: 'DELETE '.
	query printUnqualifiedTablesOn: self.
	query printUnqualifiedWhereClauseOn: self.