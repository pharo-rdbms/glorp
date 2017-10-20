constants
supportsConstraints
	"Return false, because this platform does not support constraint add or drop statements.
	However, foreign key constraints can be created as part of the create table statement.
	Also, a foreign key constraint can be created in the statement that adds that column to
	the table. (Eg., ALTER TABLE ADD COLUMN ...)."

	^false