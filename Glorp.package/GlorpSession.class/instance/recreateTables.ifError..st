table creation
recreateTables: aCollection ifError: aBlock
	"Drop the tables for our descriptor system, and their associated sequences."

	(TableSorter for: aCollection) sort reverse
		do: [ :table | accessor dropTable: table ifError: [ :ex | ex "so we can insert a breakpoint"] ].

	system platform areSequencesExplicitlyCreated
		ifTrue: [(self system allSequencesFor: aCollection)
					do: [:each | 
						accessor dropSequence: each ifAbsent: [:ex | ex "so we can insert a breakpoint" ].
						accessor createSequence: each ifError: [:ex | ^aBlock value: ex ]]].

	aCollection do: [:each | accessor createTable: each ifError: [:ex | ^aBlock value: ex]].
	aCollection do: [:each | accessor createTableIndexes: each ifError: [:ex | ^aBlock value: ex ]].
	self platform supportsConstraints ifTrue: [aCollection do: [:each | accessor createTableFKConstraints: each ifError: [:ex | ^aBlock value: ex]]]