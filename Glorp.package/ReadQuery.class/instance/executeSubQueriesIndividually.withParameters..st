executing
executeSubQueriesIndividually: subQueries withParameters: anArray
	| result |
	result := OrderedCollection new.
	subQueries do: [:eachQuery |
		| individualResult |
		individualResult := eachQuery readFromDatabaseWithParameters: anArray.
		eachQuery readsOneObject
			ifTrue: [individualResult isNil ifFalse: [^result add: individualResult]]
			ifFalse: [result addAll: individualResult]].
	^self readsOneObject
		ifTrue: [result isEmpty ifTrue: [nil] ifFalse: [result first]]
		ifFalse: [result].