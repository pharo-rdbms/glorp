tests
testCascadingDeleteAcrossNil
	| person addressRows personRows |
	session inTransactionDo: [session accessor dropConstraint: (session system tableNamed: 'PERSON') foreignKeyConstraints first].
	[
	((session system descriptorFor: GlorpPerson) mappingForAttributeNamed: #address) beExclusive.
	self setUpPersonWithAddress .

	session accessor executeSQLString: 'delete from GR_ADDRESS where ID = 2'.
	session reset.
	person := session readOneOf: GlorpPerson.
	"First, make sure this doesn't walkback"
	[session beginUnitOfWork.
	session delete: person] ensure: [session commitUnitOfWork].
	"Now make sure the address is left"
	addressRows := session accessor executeSQLString: 'SELECT * FROM GR_ADDRESS'.
	self assert: addressRows isEmpty.
	personRows :=  session accessor executeSQLString: 'SELECT * FROM PERSON'.
	self assert: personRows isEmpty.
	
	] 
		ensure: [
			session rollbackTransaction.
			session inTransactionDo: [session accessor createTableFKConstraints: (session system tableNamed: 'PERSON') ifError: [self halt]]]