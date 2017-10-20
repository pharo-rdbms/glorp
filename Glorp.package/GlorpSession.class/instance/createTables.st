table creation
createTables
	"Create the tables for our descriptor system. This will fail if the tables already exist. Use recreateTables for that."

	self createTables: system allTables.