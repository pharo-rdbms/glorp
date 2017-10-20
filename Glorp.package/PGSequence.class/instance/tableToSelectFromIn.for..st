SQL
tableToSelectFromIn: session for: aTable
	"Sometimes it's inefficient to select sequence values against our own table and we can use a database-specific system table instead to be much faster. Subclasses can override where this is the case"
	^(session databaseTableClass named: 'pg_attribute').