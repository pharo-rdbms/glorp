tests
testShouldInsertForInsert

	| testObject row |
	testObject := GlorpCustomer example1.
	testObject id: 876.
	row :=self rowFor: testObject.
	self assert: (session shouldInsert: row).