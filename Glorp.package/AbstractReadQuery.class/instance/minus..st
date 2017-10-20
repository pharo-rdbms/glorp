boolean operations
minus: aQuery
	aQuery shortCircuitEmptyReturn ifTrue: [^self].
	self shortCircuitEmptyReturn ifTrue: [^aQuery].
	^CompoundQuery newMinus addQuery: self; addQuery: aQuery