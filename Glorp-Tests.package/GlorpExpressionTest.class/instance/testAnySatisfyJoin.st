tests
testAnySatisfyJoin

	| expression base |
	system useJoinsForAnySatisfy: true.
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	expression := [:a | a items anySatisfy: [:each | each id = 7]] asGlorpExpressionOn: base.
	self assert: expression class == CollectionExpression.
	self assert: expression leftChild == expression rightChild leftChild base.