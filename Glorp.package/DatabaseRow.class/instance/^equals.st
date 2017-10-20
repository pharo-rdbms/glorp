comparing
= aRow
	self class == aRow class ifFalse: [^false].
	^self equals: aRow.