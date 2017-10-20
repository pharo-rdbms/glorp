support
addCustomerToCache
	| customer |
	customer := GlorpCustomer example1.
	customer id: 3.
	session cacheAt: 3 put: customer.
	^customer