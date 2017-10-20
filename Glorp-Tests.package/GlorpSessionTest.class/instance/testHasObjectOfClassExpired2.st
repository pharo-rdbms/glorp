tests
testHasObjectOfClassExpired2

	(session system descriptorFor: GlorpCustomer) 
		cachePolicy: (TimedExpiryCachePolicy new timeout: 0).
	self addCustomerToCache.
	self assert: (session hasObjectExpiredOfClass: GlorpCustomer withKey: 3).