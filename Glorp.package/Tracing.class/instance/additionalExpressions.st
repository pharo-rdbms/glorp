accessing
additionalExpressions
	| all |
	alsoFetchExpressions isEmpty ifTrue: [^retrievalExpressions].
	all := OrderedCollection new.
	all addAll: self retrievalExpressions.
	all addAll: self alsoFetchExpressions.
	^all.