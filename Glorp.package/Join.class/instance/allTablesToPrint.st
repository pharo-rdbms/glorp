preparing
allTablesToPrint

	^targets inject: Set new into: [:sum :each | 
		sum add: each table. sum].