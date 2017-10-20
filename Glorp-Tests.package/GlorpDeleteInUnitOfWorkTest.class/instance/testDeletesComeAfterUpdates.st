tests
testDeletesComeAfterUpdates
	unitOfWork delete: GlorpAddress example1.
	unitOfWork register: GlorpCustomer example1.
	unitOfWork commit.
	self assert: unitOfWork session rows last table == (self tableNamed: 'GR_ADDRESS').