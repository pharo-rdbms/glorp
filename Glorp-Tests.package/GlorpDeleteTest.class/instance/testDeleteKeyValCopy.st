tests
testDeleteKeyValCopy
	"Delete an object that shares key values only with the deletion target."

	| person keyValPerson keyValAddress |
	keyValPerson := GlorpPerson new.
	keyValAddress := GlorpAddress new.
	
	[person := self setUpPersonWithAddress.
	keyValPerson id: person id.
	keyValAddress id: person address id.
	session beginUnitOfWork.
	session delete: keyValPerson.
	session delete: keyValAddress.
	session commitUnitOfWork.
	self checkPersonDeletedInDatabase.] 
		ensure: [session rollbackTransaction].