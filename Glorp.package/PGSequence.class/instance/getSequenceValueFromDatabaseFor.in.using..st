SQL
getSequenceValueFromDatabaseFor: aDatabaseField in: aDatabaseRow using: anAccessor

	| statement rows pk |

	"this could be made smarter by aggregating keys to fetch into a single sql query - maybe later -tb"
	statement := 'select nextval(''',  self qualifiedName, ''')'.

	rows := anAccessor executeSQLString: statement.
	pk := rows first first.

	aDatabaseRow at: aDatabaseField put: pk.