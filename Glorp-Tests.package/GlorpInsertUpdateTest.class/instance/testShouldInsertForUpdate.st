tests
testShouldInsertForUpdate

	| testObject row |
	session beginUnitOfWork.
	testObject := GlorpCustomer example1.
	testObject id: 876.
	session cacheAt: 876 put: testObject.
	row :=self rowFor: testObject.
	self deny: (session shouldInsert: row).