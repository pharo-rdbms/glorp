sql generation
computeTablesToPrint
	| allTables stoppingPoint |
	allTables := Set new.
	fields do: [:each | allTables addAll: each tablesToPrint].
	stoppingPoint := base.
	allTables
		addAll:
			(stoppingPoint isNil
				ifTrue: [whereClause allTablesToPrint]
				ifFalse: [whereClause allTablesToPrintStoppingAt: stoppingPoint]).
	joins
		do:
			[:eachJoin | 
			allTables
				addAll:
					(stoppingPoint isNil
						ifTrue: [eachJoin allTablesToPrint]
						ifFalse: [eachJoin allTablesToPrintStoppingAt: stoppingPoint])].
	ordering isNil
		ifFalse: [ordering do: [:each | 
			each field isNil ifFalse: [allTables add: each field table]]].
	grouping isNil
		ifFalse: [grouping do: [:each |
			each field isNil ifFalse: [allTables add: each field table]]].
	self tracing allTracings
		do: [:each | allTables addAll: each allTablesToPrint].
	^allTables asSortedCollection