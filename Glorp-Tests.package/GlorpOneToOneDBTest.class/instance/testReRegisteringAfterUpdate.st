tests-read
testReRegisteringAfterUpdate
	"Test that even if we re-register the object after it's been modified, we still write the changes."

	self
		inTransactionDo:
			[self writePersonWithAddress.
			session reset.
			session beginUnitOfWork.
			person := (session read: GlorpPerson) first.
			person name: 'new name'.
			session register: person.
			session commitUnitOfWork.
			session reset.
			self readPerson.
			self assert: person name = 'new name'].