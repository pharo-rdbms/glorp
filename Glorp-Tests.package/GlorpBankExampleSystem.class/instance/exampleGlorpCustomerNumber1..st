examples
exampleGlorpCustomerNumber1: aCustomer

	aCustomer id: 1.
	aCustomer name: 'Fred Flintstone'.
	aCustomer addTransaction: (self objectNumber: 1 ofClass: GlorpBankTransaction).
	aCustomer addTransaction: (self objectNumber: 2 ofClass: GlorpBankTransaction).
	aCustomer addAccount: (self objectNumber: 1 ofClass: GlorpBankAccount).
	aCustomer addAccount: (self objectNumber: 2 ofClass: GlorpBankAccount).