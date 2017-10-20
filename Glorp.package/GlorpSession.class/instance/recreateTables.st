table creation
recreateTables
	"Drop and re-create the tables for our descriptor system, and their associated sequences."

	self recreateTables: system allTables.