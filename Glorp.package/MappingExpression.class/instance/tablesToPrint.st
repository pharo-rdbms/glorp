preparing
tablesToPrint

	self hasDescriptor ifFalse: [^#()].
	^self tables collect: [:each |
		self aliasedTableFor: each].