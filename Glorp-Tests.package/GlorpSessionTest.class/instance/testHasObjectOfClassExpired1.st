tests
testHasObjectOfClassExpired1

	self addCustomerToCache.
	self deny: (session hasObjectExpiredOfClass: GlorpCustomer withKey: 3).