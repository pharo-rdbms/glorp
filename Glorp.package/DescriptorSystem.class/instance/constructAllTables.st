initialization
constructAllTables
	"Subclasses can override this method to add tables to the list. But by default we also look for all table methods in our system, and add them to the class list, so if the methods are written there, then we don't need to do anything further. If the table methods are defined on the classes themselves, then we'll still have to construct the list manually."
	self allTableNames do: [:each | 
		self tableNamed: each asString].
	self constructTablesFromInitializeMethods.
	^tables.