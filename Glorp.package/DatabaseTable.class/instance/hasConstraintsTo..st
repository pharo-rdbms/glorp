testing
hasConstraintsTo: aTable
	self foreignKeyConstraints
		do: [:each | (each refersToTable: aTable) ifTrue: [^true]].
	^false.