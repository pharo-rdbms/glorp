boolean operations
unionAll: aQuery
	aQuery shortCircuitEmptyReturn ifTrue: [^self].
	self shortCircuitEmptyReturn ifTrue: [^aQuery].
	^CompoundQuery newUnionAll addQuery: self; addQuery: aQuery