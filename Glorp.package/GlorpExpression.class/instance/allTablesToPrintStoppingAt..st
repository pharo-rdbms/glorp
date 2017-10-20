preparing
allTablesToPrintStoppingAt: aSubSelectBaseExpression

	^self inject: Set new into: [:sum :each | 
		each queryLevelBaseExpression == aSubSelectBaseExpression ifTrue: [
			sum addAll: each tablesToPrint]. sum].