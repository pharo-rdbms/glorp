mapping
query

	query isNil ifTrue: [self buildQuery].
	^query.