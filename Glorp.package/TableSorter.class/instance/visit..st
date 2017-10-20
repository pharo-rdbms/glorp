sorting
visit: aTable 
	"The essential bit of topological sort. Visit each node in post-order, traversing dependencies, based on foreign key constraints to database-generated fields. "

	(self hasBeenVisited: aTable) ifTrue: [^self].
	self markVisited: aTable.
	self visitDependentTablesFor: aTable.
	orderedTables add: aTable