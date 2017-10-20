mapping
buildQuery
	query := super buildQuery.
	orderBy isNil ifFalse: [orderBy do: [:each | query orderBy: each]].
	^query