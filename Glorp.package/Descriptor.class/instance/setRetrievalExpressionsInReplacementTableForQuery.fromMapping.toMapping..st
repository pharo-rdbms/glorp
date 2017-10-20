internal
setRetrievalExpressionsInReplacementTableForQuery: subQuery fromMapping: sourceMapping toMapping: targetMapping
	self primaryTable fields
		do:
			[:each | 
			| sourceReplacement replacement expression |
			sourceReplacement := sourceMapping join targetForSource: each.
			replacement := sourceReplacement isNil
				ifTrue: [targetMapping join targetForSource: each]
				ifFalse: [sourceReplacement].
			expression := replacement isGlorpExpression
				ifTrue: [replacement] 
				ifFalse: [(BaseExpression new getTable: replacement table) getField: replacement].
			expression alias: each name.
			subQuery retrieve: expression]