As yet unclassified
shortCircuitOnNullComparison: anIdentityDictionary 
	joins do: [:each |
		(each shortCircuitOnNullComparison: anIdentityDictionary)
			ifFalse: [^false]].
	^true.