accessing
mappedFields
	
	self mapping isNil ifTrue: [^#()].
	self mapping isRelationship ifTrue: [self error: '"',name, '" is not an attribute that resolves to a field in the mapped tables for ', base descriptor describedClass name].
	^self mapping mappedFields collect: [:each | base translateField: each].