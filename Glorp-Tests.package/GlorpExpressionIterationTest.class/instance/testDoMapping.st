tests
testDoMapping

	| exp |
	exp := MappingExpression new.
	exp named: 'foo' basedOn: BaseExpression new.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: exp base with: exp)).