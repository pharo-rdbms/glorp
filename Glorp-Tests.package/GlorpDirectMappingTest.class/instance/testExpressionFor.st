tests
testExpressionFor
	| cust exp |
	cust := GlorpCustomer new.
	cust id: 12.
	exp := mapping
		expressionFor: cust
		basedOn: BaseExpression new
		relation: #=.
	self assert: exp rightChild class == ConstantExpression.
	self assert: exp rightChild value = 12.
	self assert: exp relation = #=.
	self assert: exp leftChild class == MappingExpression.