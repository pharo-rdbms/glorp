preparing
prepareIn: aQuery
	"A little weird, because what we end up asking for additional expressions from, might not be us"

	aQuery adjustWhereClause.
	(aQuery whereClause additionalExpressionsIn: aQuery)
		do:
			[:each | 
			(aQuery shouldExpressionBeJoin: each)
				ifTrue: [aQuery addJoin: each]
				ifFalse: [aQuery privateAnd: each]].