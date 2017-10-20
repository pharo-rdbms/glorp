tests
testDoRelation

	| exp l r |
	exp := RelationExpression new.
	l := BaseExpression new.
	r := BaseExpression new.
	exp leftChild: l; rightChild: r.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: l with: r with: exp)).