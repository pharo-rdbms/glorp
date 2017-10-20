tests
testPrimaryKeyExpressionFor
	| descriptor trans exp |
	descriptor := system descriptorFor: GlorpBankTransaction.
	trans := GlorpBankTransaction new.
	trans id: 42.
	exp := descriptor
		primaryKeyExpressionFor: trans
		basedOn: BaseExpression new
		relation: #=.
	self assert: exp relation = #=.
	self assert: exp rightChild value = 42.