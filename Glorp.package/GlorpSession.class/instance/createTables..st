table creation
createTables: aCollection
	"Create the tables for our descriptor system. This will fail if the tables already exist. Use recreateTables for that."

	| sequences |
	system platform areSequencesExplicitlyCreated
		ifTrue:
			[sequences := self system allSequencesFor: aCollection.
			sequences do: [:each | accessor createSequence: each ifError: [:ex | ex signal]]].
	aCollection do: [:each | accessor createTable: each ifError: [:ex | ex signal ]].
	aCollection do: [:each | accessor createTableIndexes: each ifError: [:ex | ex signal]].
	self platform supportsConstraints ifTrue: [aCollection do: [:each | accessor createTableFKConstraints: each ifError: [:ex | ex signal]]]