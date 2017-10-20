tests
testAnySatisfyExists

	| expression base |
	system useJoinsForAnySatisfy: false.
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	expression := [:a | a items anySatisfy: [:each | each id = 7]] asGlorpExpressionOn: base.
	self assert: expression class == SubSelectExpression.