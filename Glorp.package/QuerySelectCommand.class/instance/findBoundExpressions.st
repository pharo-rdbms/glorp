accessing
findBoundExpressions
	self useBinding ifFalse: [^nil].
	boundExpressions := OrderedCollection new.
	query addBoundExpressionsIn: self to: boundExpressions.