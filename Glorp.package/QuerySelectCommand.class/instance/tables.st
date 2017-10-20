reporting
tables
	^(self query tablesToPrint collect: [:each | each parent]) asSet.