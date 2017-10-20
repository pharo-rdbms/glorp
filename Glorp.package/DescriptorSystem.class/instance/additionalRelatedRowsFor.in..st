callbacks
additionalRelatedRowsFor: aRow in: aRowMap
	"This method serves as a hook. It is called when sorting rows before writing to the database, and can be used to return a list of additional related rows that aren't found by the normal foreign key constraints. These rows will act as an ordering constraint, and will have to be written before aRow."
	^nil