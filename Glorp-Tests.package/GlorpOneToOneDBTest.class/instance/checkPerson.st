support
checkPerson
	self assert: person class = GlorpPerson.
	self assert: person id = personId.
	self assert: person name = 'aPerson'.