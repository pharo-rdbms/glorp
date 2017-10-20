tests-write
testWritePersonWithEmailAddresses

	| newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson example1.
		newPerson id: 231.
		personId := 231.	
		newPerson emailAddresses: OrderedCollection new.
		newPerson emailAddresses add: (GlorpEmailAddress new id: 2; user: 'one'; host: 'blorch.ca').
		newPerson emailAddresses add: (GlorpEmailAddress new id: 3; user: 'two'; host: 'blorch.ca').
		emailId1 := 2.
		emailId2 := 3.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self checkEmailAddresses: person emailAddresses.
		self checkNumberOfEmailAddressesInDB: 2].