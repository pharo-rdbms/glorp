accessing
addTransaction: aTransaction

	transactions add: aTransaction.
	aTransaction owner: self.