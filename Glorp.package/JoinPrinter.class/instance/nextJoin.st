printing
nextJoin
	^joinsToProcess detect: [:eachJoinExpression |
		eachJoinExpression tablesForANSIJoin anySatisfy: [:eachTable |
			availableTables includes: eachTable]]