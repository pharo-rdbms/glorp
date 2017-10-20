testing
assertEqual: aCustomer

	onlinePurchases assertEqual: aCustomer onlinePurchases.
	inStorePurchases assertEqual: aCustomer inStorePurchases.
	inStoreRentals assertEqual: aCustomer inStoreRentals.
	creditStatus assertEqual: aCustomer creditStatus.
	self assert: store id = aCustomer videoStore id.
	self assert: name = aCustomer name.
	self assert: dateOfBirth = aCustomer dateOfBirth.