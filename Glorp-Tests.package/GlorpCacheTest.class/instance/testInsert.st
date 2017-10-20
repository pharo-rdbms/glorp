tests
testInsert
	| customer |
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self assert: (cache lookupClass: GlorpCustomer key: 3) == customer