accessing
nonPrimaryKeyFields
	| result |
	result := OrderedCollection new: contents size.
	self fieldsDo: [:field | 
		field isPrimaryKey ifFalse: [result add: field]].
	^result.