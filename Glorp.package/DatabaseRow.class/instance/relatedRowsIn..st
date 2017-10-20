relationships
relatedRowsIn: aRowMap
	| relatedRows |
	relatedRows := OrderedCollection new.
	self table foreignKeyConstraints
		do:
			[:eachConstraint | relatedRows addAll: (eachConstraint rowsRelatedTo: self)].
	^relatedRows.