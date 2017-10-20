boolean operations
minus: aQuery
	aQuery shortCircuitEmptyReturn ifTrue: [^self].
	^CompoundQuery newMinus addQuery: self; addQuery: aQuery