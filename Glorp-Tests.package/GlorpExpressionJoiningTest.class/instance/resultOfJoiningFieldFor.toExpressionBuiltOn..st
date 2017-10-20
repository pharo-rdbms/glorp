tests
resultOfJoiningFieldFor: aTable toExpressionBuiltOn: anotherTable
	| exp table |
	base descriptor: (system descriptorFor: GlorpCustomer).
	exp := FieldExpression forField: (aTable fieldNamed: 'ID')
				basedOn: BaseExpression new.
	table := base getTable: anotherTable.

	^exp asExpressionJoiningSource: base toTarget: table.