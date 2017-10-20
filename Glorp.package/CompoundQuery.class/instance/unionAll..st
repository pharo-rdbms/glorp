boolean operations
unionAll: aQuery
	aQuery shortCircuitEmptyReturn ifTrue: [^self].
	^self isUnionAll
		ifTrue:
			[queries add: aQuery.
			self]
		ifFalse:
			[(CompoundQuery newUnionAll)
				addQuery: self;
				addQuery: aQuery]