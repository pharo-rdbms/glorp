tests
testExpiryReturningNilWithRealDelay
	"test that objects expire with a non-zero delay time."
	| customer customer2 |
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self deny: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	(Delay forSeconds: 2) wait.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	customer2 := GlorpCustomer new.
	cache at: 3 insert: customer2.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == customer2.