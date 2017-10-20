tests
testDoTable

	| exp |
	exp := TableExpression new.
	exp table: nil base: BaseExpression new.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: exp base with: exp)).