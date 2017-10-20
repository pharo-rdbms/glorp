converting
asGeneralGlorpExpression
	"We know that we represent querying for an abstract class, so we don't want to convert ourselves to a join form, but rather just to a source mapping form. There are some assumptions in here, but it should work for the basic cases anyway."

	| base expression anyJoin descriptor |
	anyJoin := self anyJoin.
	base := anyJoin base.
	descriptor := base system findDescriptorForTable: anyJoin allTargetFields first table.
	expression := EmptyExpression new base: base.
	anyJoin mappableFieldsDo: [:source :target |
		| mapping thingToCompare |
		mapping := descriptor mappingForField: target.
		thingToCompare := mapping isNil
			ifTrue: [base getField: target]
			ifFalse: [base get: mapping attributeName].
		expression := expression AND: (thingToCompare get: #= withArguments: (Array with: (source asGlorpExpressionOn: base)))].
	^expression.