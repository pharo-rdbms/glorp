table creation
dropTables
	"Drop the tables for our descriptor system, and their associated sequences."

	self dropTables: system allTables.