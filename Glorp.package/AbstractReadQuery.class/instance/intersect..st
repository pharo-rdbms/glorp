boolean operations
intersect: aQuery
	aQuery shortCircuitEmptyReturn ifTrue: [^aQuery].
	self shortCircuitEmptyReturn ifTrue: [^self].
	^CompoundQuery newIntersect addQuery: self; addQuery: aQuery