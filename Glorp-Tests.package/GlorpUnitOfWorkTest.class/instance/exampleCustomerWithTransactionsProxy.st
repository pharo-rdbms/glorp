support
exampleCustomerWithTransactionsProxy
	| customer |
	customer := GlorpCustomer new.
	customer transactions: self exampleTransactionsProxy.
	^customer