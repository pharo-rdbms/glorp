accessing
canCauseDuplicateRows
	^expression class == MappingExpression and: [expression mapping isToManyRelationship]