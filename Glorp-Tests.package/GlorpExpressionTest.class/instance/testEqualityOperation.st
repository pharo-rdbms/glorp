tests
testEqualityOperation
	| expression fred base |
	fred := 'Fred'.
	base := BaseExpression new.
	expression := [:a | a firstName = fred] asGlorpExpressionOn: base.
	self assert: expression leftChild == (base get: #firstName).
	self assert: expression rightChild class == ConstantExpression.
	self assert: expression rightChild value == fred.
	self assert: expression relation == #=