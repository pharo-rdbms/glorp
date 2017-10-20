tests
testOrOperation2
	| expression fred base |
	fred := 'Fred'.
	base := BaseExpression new.
	expression := [:a | (a firstName = fred) OR: (a firstName ~= fred)] asGlorpExpressionOn: base.
	self assert: expression class == RelationExpression.
	self assert: expression relation = #OR.