creating mappings
directMappingFor: attributeName
	"Create a direct mapping from the attribute of this name to the field in the table with a matching name. For convenience when there's a good correspondence between the field and instance variable names."
	| field |
	self tables do: [:each |
		field := each fieldNamed: attributeName ifAbsent: [nil] caseSensitive: false].
	field isNil ifTrue: [self error: 'Cannot find field named ', attributeName printString].
	^self directMapping from: attributeName to: field