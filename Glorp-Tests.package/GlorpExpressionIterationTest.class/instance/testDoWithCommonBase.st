tests
testDoWithCommonBase

	| exp l r base |
	exp := RelationExpression new.
	base := BaseExpression new.
	l := MappingExpression new.
	l named: nil basedOn: base.
	r := MappingExpression new.
	r named: nil basedOn: base.
	exp leftChild: l; rightChild: r.	
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: base with: l with: r with: exp)).