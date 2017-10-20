mapping
primaryKeyMappings
	"Return things that map to our primary key fields. Prefer direct mappings"
	| fields pkMappings |
	fields := self primaryTable primaryKeyFields.
	pkMappings := OrderedCollection new: fields size.
	fields do: [:each |  | mapping |
		mapping := self directMappingForField: each.
		mapping isNil ifTrue: [mapping := self mappingForField: each].
		mapping isNil ifFalse: [pkMappings add: mapping]].
	^pkMappings