preparing
tablesToPrint

	self controlsTables ifFalse: [^#()].
	^Array with: (self aliasedTableFor: table).