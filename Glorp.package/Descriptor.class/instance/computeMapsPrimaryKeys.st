testing
computeMapsPrimaryKeys
	| primaryKeyFields |
	self tables isEmpty ifTrue: [^false].
	primaryKeyFields := self primaryTable primaryKeyFields.
	primaryKeyFields isEmpty ifTrue: [^false].
	primaryKeyFields
		do: [:each | (self mappedFields anySatisfy: [ :eachMappedField |
			eachMappedField = each]) ifFalse: [^false]].
	^true.