mapping
buildQuery
	query := CompositeQuery new.
	self conditional casesDo: [:each |
		query addQuery: each query].
	^query