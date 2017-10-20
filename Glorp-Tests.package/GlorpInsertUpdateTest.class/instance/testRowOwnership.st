tests
testRowOwnership

	| aCustomer rowMap |
	aCustomer := GlorpCustomer new.
	rowMap := RowMap new.
	(session descriptorFor: GlorpCustomer) createRowsFor: aCustomer in: rowMap.
	rowMap rowsDo: [:each | 
		self assert: each owner = aCustomer].