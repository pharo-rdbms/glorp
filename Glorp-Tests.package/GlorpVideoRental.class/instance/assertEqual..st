testing
assertEqual: aRental

	self assert: customer name = aRental customer name.
	self assert: customer dateOfBirth = aRental customer dateOfBirth.
	self assert: id = aRental id.
	self assert: title = aRental title.
	self assert: price = aRental price.
	self assert: dueDate = aRental dueDate.