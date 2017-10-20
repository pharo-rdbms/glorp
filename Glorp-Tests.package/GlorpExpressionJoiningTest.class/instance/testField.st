tests
testField
	| exp  result |
	exp := FieldExpression forField: (DatabaseField named: 'test' type: system platform int4)
				basedOn: base.
	result := self join: exp.
	self assert: result base == source.
	self assert: result field == exp field