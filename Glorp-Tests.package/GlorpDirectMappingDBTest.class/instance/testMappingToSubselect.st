tests
testMappingToSubselect

	| personDescriptor people |
	[session beginTransaction.
	self writeAddress.
	self writeHomelessPerson.
	self writePersonWithEmailAddresses.
	personDescriptor := system descriptorFor: GlorpPerson.
	(personDescriptor newMapping: DirectMapping)
		beReadOnly;
		type: Boolean;
		from: #hasEmail 
		to: [:each | each emailAddresses notEmpty].
	people := session read: GlorpPerson orderBy: #id.
	self assert: people first hasEmail.
	self deny: people last hasEmail.
	self assert: people first emailAddresses notEmpty.
	self assert: people last emailAddresses isEmpty.
	 ]
		ensure: [session rollbackTransaction].