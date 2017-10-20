tests
testBetweenAnd
	| expression base |
	base := BaseExpression new.
	expression := [:a | a between: 3 and: 4] asGlorpExpressionOn: base.
	self assert: expression class == InfixFunction.
	self assert: expression name = 'BETWEEN AND'.
	self assert: (expression arguments collect: [:each | each value]) = (Array with: 3 with: 4).