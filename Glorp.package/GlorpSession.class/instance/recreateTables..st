table creation
recreateTables: aCollection
	"Drop the tables for our descriptor system, and their associated sequences."

	| sequences |
	accessor dropTables: (TableSorter for: aCollection) sort reverse.
	system platform areSequencesExplicitlyCreated
		ifTrue:
			[
			sequences := self system allSequencesFor: aCollection.
			accessor dropSequences: sequences.
			sequences
				do: [:each | accessor createSequence: each ifError: [:ex | self halt]]].
	aCollection do: [:each | accessor createTable: each ifError: [:ex | self halt]].
	aCollection do: [:each | accessor createTableIndexes: each ifError: [:ex | self halt]].
	self platform supportsConstraints ifTrue: [aCollection do: [:each | accessor createTableFKConstraints: each ifError: [:ex | self halt]]]