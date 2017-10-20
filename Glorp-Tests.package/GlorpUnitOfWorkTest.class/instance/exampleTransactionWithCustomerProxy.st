support
exampleTransactionWithCustomerProxy
	| transaction |
	transaction := GlorpBankTransaction example1.
	transaction owner: self exampleCustomerProxy.
	^transaction