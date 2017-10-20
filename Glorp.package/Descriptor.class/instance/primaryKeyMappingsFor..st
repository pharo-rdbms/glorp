deleting
primaryKeyMappingsFor: aTable
	"Return our primary key mappings as a collection of mappings, one collection per primary key"

	| allMappings |
	allMappings := Dictionary new: aTable primaryKeyFields size.
	aTable primaryKeyFields
		do: [:each | 
			| mappingsForField |
			mappingsForField := self mappingsForFields at: each ifAbsent: [nil].
			mappingsForField isNil ifFalse: [allMappings at: each put: mappingsForField]].
	^allMappings