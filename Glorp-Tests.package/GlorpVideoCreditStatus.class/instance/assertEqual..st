testing
assertEqual: aCreditStatus

	self assert: customer name = aCreditStatus customer name.
	self assert: customer dateOfBirth = aCreditStatus customer dateOfBirth.
	self assert: balanceOwing = aCreditStatus balanceOwing.
	self assert: dateOwing = aCreditStatus dateOwing.
	self assert: comments = aCreditStatus comments.