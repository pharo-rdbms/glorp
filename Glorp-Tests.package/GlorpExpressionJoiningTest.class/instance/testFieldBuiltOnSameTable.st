tests
testFieldBuiltOnSameTable
	| exp result base2 table custTable |
	custTable := system tableNamed: 'GR_CUSTOMER'.
	base2 := BaseExpression new.
	base2 descriptor: (system descriptorFor: GlorpCustomer).
	table := base2 getTable: custTable.
	exp := FieldExpression forField: (custTable fieldNamed: 'ID')
				basedOn: base.
	result := exp asExpressionJoiningSource: base2 toTarget: table.
	self assert: result base == table.
	self assert: result field == exp field.