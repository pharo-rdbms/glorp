preparing
assignTableAliasesStartingAt: anInteger prefix: aString
	| tableNumber prefix |
	self controlsTables ifFalse: [^anInteger].
	self hasTableAliases ifTrue: [^anInteger].
	tableNumber := anInteger.
	prefix := aString isNil ifTrue: ['t'] ifFalse: [aString].
	self tables
		do:
			[:each | 
			self aliasTable: each to: prefix , tableNumber printString.
			tableNumber := tableNumber + 1].
	^tableNumber.