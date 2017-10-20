accessing
tables

	self controlsTables ifFalse: [^#()].
	^self tablesContainingMe.