sequencing
getSequenceValueFromDatabaseFor: aDatabaseField in: aDatabaseRow using: anAccessor 
	| statement rows pk |
	statement := 'select gen_id(' , self qualifiedName 
				, ',1) from rdb$database'.
	rows := anAccessor executeSQLString: statement.
	pk := rows first first.
	aDatabaseRow at: aDatabaseField put: pk