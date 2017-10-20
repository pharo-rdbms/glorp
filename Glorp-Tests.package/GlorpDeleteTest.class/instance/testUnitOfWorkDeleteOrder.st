tests
testUnitOfWorkDeleteOrder
	| person |
	
	[person := self setUpPersonWithAddress.
	session beginUnitOfWork.
	session delete: person.
	session delete: person address.
	session commitUnitOfWork.
	self checkPersonDeletedInDatabase.] 
			ensure: [session rollbackTransaction]