tests
testAndOperation2
	| expression fred base |
	fred := 'Fred'.
	base := BaseExpression new.
	expression := [:a | (a firstName = fred) AND: (a firstName ~= fred)] asGlorpExpressionOn: base.
	self assert: expression class == RelationExpression.
	self assert: expression relation = #AND.