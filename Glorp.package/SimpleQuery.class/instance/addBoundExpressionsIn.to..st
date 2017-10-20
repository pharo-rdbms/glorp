accessing
addBoundExpressionsIn: aCommand to: aCollection
	self joins , self fields, (Array with: self whereClause)
		do:
			[:eachBigExpression | 
			eachBigExpression isGlorpExpression
				ifTrue: [eachBigExpression do:
					[:eachIndividualExpressionNode | 
					eachIndividualExpressionNode
						addBoundExpressionsIn: aCommand
						to: aCollection]]]