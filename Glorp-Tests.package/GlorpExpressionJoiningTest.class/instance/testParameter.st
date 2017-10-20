tests
testParameter
	| result exp table field |
	table := DatabaseTable named: 'T'.	
	field := DatabaseField named: 'F' type: system platform int4.
	table addField: field.
	exp := base getParameter: field.
	result := self join: exp.
	self assert: result base == source.
	self assert: result class == FieldExpression.
	self assert: result field == field.