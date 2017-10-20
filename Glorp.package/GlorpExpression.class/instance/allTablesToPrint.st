preparing
allTablesToPrint

	^self inject: Set new into: [:sum :each | 
		sum addAll: each tablesToPrint. sum].