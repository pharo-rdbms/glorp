tests
testRemove
	| customer |
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self assert: (cache lookupClass: GlorpCustomer key: 3) == customer.
	cache removeClass: GlorpCustomer key: 3 ifAbsent: [ self signalFailure: 'Item was not in cache.' ].
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: []) == nil.