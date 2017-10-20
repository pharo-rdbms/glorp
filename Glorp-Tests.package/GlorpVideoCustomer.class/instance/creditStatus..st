accessing
creditStatus: aCreditStatus
	creditStatus := aCreditStatus.
	creditStatus isNil ifFalse: [creditStatus customer: self].