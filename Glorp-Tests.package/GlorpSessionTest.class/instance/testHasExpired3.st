tests
testHasExpired3
	| customer |
	(session system descriptorFor: GlorpCustomer) 
		cachePolicy: (TimedExpiryCachePolicy new timeout: 0).
	customer := self addCustomerToCache.
	self assert: (session hasExpired: customer)