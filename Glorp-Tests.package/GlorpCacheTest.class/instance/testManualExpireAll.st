tests
testManualExpireAll
	| customer customer2 readBackCustomer |
	system cachePolicy: TimedExpiryCachePolicy new.
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self deny: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	cache expireAll.
	readBackCustomer := session readOneOf: GlorpCustomer where: [:each | each id = 3].
	self assert: readBackCustomer isNil.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	customer2 := GlorpCustomer new.
	cache at: 3 insert: customer2.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == customer2.