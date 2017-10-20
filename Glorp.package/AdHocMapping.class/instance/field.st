mapping
field
	| fields |
	fields := self mappedFields.
	fields size = 1 ifFalse: [self error: 'This mapping does not correspond to exactly one field'].
	^fields first