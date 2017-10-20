accessing
fields
	^self table fields select: [:each | (self includesField: each)].