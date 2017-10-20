accessing
buildQuery
	query := super buildQuery.
	query retrieve: [:x | x getField: resultField].
	^query