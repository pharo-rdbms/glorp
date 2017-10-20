preparing
allTables

	^self inject: Set new into: [:sum :each | 
		sum addAll: each tables. sum].