accessing
singleRowBoundFields
	| fields |
	fields := row table primaryKeyFields.
	fields isEmpty ifTrue: [fields := row fields].
	^fields asArray