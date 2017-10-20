converting
asGeneralGlorpExpressionWithFields
	"The normal conversion of a join is to an expression equating fields and parameters. Instead, generate one with field to field comparisons."

	| base expression mappingName anyJoin descriptor |
	anyJoin := self anyJoin.
	base := anyJoin base.
	descriptor := base system findDescriptorForTable: anyJoin allTargetFields first table.
	expression := EmptyExpression new base: base.
	anyJoin mappableFieldsDo: [:source :target |
		mappingName := (descriptor mappingForField: target) attributeName.
		expression := expression AND: ((base get: mappingName) get: #= withArguments: (Array with: (self targetExpressionFor: source)))].
	^expression.