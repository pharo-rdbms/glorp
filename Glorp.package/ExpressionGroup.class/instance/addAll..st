accessing
addAll: anExpressionCollection
	anExpressionCollection isNil ifTrue: [^self].
	children addAll: anExpressionCollection.