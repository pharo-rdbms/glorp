tests
checkCustomerNotInCache
	self assert: (session cacheLookupForClass: GlorpCustomer key: 1) isNil