accessing
table: aDatabaseTable
	
	| table |
	table := aDatabaseTable isString
		ifTrue: [table := self system tableNamed: aDatabaseTable]
		ifFalse: [aDatabaseTable].
	tables add: table