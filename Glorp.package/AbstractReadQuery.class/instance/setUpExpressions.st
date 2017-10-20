executing
setUpExpressions
	(whereClause isGlorpExpression and: [ whereClause queryLevelBaseExpression notNil ])
		ifTrue:
			[ base := whereClause queryLevelBaseExpression.
			base hasDescriptor
				ifFalse: [ base descriptor: (session descriptorFor: resultClass) ] ]
		ifFalse:
			[ base isNil
				ifTrue: [ base := BaseExpression new ].
			base descriptor: (session descriptorFor: resultClass).
			whereClause := whereClause asGlorpExpressionOn: base in: self ].
	ordering isNil
		ifFalse:
			[ordering := ordering
				collect:
					[:each | (self expressionBlockFor: each) asGlorpExpressionOn: base in: self]].
	grouping isNil 
		ifFalse:
			[grouping := grouping
				collect:
					[:each | (self expressionBlockFor: each) asGlorpExpressionOn: base in: self]].	
	tracing isNil
		ifFalse: [ tracing updateBase: base ].
	base descriptor typeResolver setUpExpressionsForQuery: self