table creation
dropTables: aCollection
	"Drop the tables for our descriptor system, and their associated sequences."

	| sequences |
	accessor dropTables: (TableSorter for: aCollection) sort reversed.
	system platform areSequencesExplicitlyCreated
		ifTrue: [ 
			sequences := system allSequencesFor: aCollection.
			accessor dropSequences: sequences ]