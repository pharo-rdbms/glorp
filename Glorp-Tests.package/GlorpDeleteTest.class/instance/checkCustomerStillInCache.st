tests
checkCustomerStillInCache
	self assert: (session cacheLookupForClass: GlorpCustomer key: 1) notNil