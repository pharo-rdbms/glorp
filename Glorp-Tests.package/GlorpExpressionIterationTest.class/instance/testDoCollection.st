tests
testDoCollection

	| exp l r |
	exp := CollectionExpression new.
	l := BaseExpression new.
	r := BaseExpression new.
	exp leftChild: l; rightChild: r.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: r with: exp)).