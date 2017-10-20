*Glorp-Tests
createTables
	"Create the tables for this descriptor system. This will fail if the tables already exist. Use recreateTables for that."
	^self createTablesFor: GlorpDatabaseLoginResource current login.