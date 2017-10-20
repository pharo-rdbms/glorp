tests
testDoField

	| exp |
	exp := FieldExpression new.
	exp field: nil base: BaseExpression new.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: exp base with: exp)).