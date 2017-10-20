tests
testPrimaryKeyExpressionForFailing
	| descriptor trans |
	descriptor := system descriptorFor: GlorpBankTransaction.
	trans := GlorpCustomer new.
	self
		should:
			[descriptor
				primaryKeyExpressionFor: trans
				basedOn: BaseExpression new
				relation: #=]
		raise: self errorSignal.