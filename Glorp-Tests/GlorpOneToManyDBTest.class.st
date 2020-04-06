Class {
	#name : #GlorpOneToManyDBTest,
	#superclass : #GlorpMappingDBTest,
	#instVars : [
		'person',
		'personId',
		'emailId1',
		'emailId2',
		'emailId3'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #support }
GlorpOneToManyDBTest >> checkEmailAddresses: emailAddresses [
	| sorted numberOfAddresses |
	numberOfAddresses := (emailId1 isNil ifTrue: [0] ifFalse: [1]) + (emailId2 isNil ifTrue: [0] ifFalse: [1]) + (emailId3 isNil ifTrue: [0] ifFalse: [1]).
	self assert: emailAddresses size = numberOfAddresses.
	sorted := emailAddresses asSortedCollection: [:a :b | a id <= b id].
	emailId1 isNil ifFalse: [self assert: sorted first id = emailId1].
	emailId2 isNil ifFalse: [self assert: (sorted at: 2) id = emailId2].
	emailId3 isNil ifFalse: [self assert: sorted last id = emailId3].
	self assert: (emailAddresses collect: [:each | each id]) asSet size = emailAddresses size.
]

{ #category : #support }
GlorpOneToManyDBTest >> checkNumberOfEmailAddressesInDB: numberOfAddresses [
	| databaseAddresses |
	databaseAddresses := session accessor executeSQLString: 'SELECT * FROM EMAIL_ADDRESS'.
	self assert: databaseAddresses size = numberOfAddresses.
]

{ #category : #support }
GlorpOneToManyDBTest >> inUnitOfWorkDo: aBlock initializeWith: initBlock [
	"Set up a bunch of the normal data, read the objects, then run the block in a unit of work"
	initBlock value.
	session beginUnitOfWork.
	self readPerson.
	aBlock value.
	session commitUnitOfWork.
	session reset.
]

{ #category : #support }
GlorpOneToManyDBTest >> readPerson [
	| results query |
	query := Query
		read: GlorpPerson
		where: [:pers | pers id = personId].
	results := query executeIn: session.
	self assert: results size = 1.
	person := results first.
]

{ #category : #'tests-join' }
GlorpOneToManyDBTest >> setUpSomeExtraPeople [
	self
		inUnitOfWorkDo:
			[| otherPerson |
			session register: (GlorpPerson new id: 9924365).
			otherPerson := GlorpPerson new id: 12121.
			otherPerson
				emailAddresses:
					(OrderedCollection
						with:
							((GlorpEmailAddress new)
								id: 7;
								host: 'asdfasdf')).
			session register: otherPerson]
		initializeWith: [self writePersonWithEmailAddresses].
]

{ #category : #support }
GlorpOneToManyDBTest >> tearDown [
	((session system descriptorFor: GlorpPerson) mappingForAttributeNamed: #emailAddresses) isExclusive: false.
	super tearDown.
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadActionWithCollection [
	| collection |
	self
		inTransactionDo:
			[collection := OrderedCollection new.
			self writePersonWithEmailAddresses.
			((session system descriptorFor: GlorpPerson)
				mappingForAttributeNamed: #emailAddresses)
				proxyAction:
					[:owner :object | object do: [:each | collection add: owner -> each]].
			person := session readOneOf: GlorpPerson.
			person emailAddresses yourSelf.
			self assert: collection size = 2.
			self assert: collection first = (person -> person emailAddresses first).
			self assert: collection last = (person -> person emailAddresses last)].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadJustTheEmailAddressNotThePersonAndWriteBackWithChanges [
	| addresses addressRows |
	"We won't have the person object to set a value for the PERSON_ID field. Ensure that we don't write a null for that field, or otherwise modify things."
	self inTransactionDo: [	
		self writePersonWithEmailAddresses.
		session beginUnitOfWork.
		addresses := session read: GlorpEmailAddress.
		addresses do: [:each | each host: 'bar.org'].
		self assert: ((session privateGetCache cacheForClass: GlorpPerson) at: 3 ifAbsent: [nil]) isNil.
		session commitUnitOfWork.
		addressRows := session accessor executeSQLString: 'SELECT PERSON_ID, HOST_NAME from EMAIL_ADDRESS'.
		self assert: addressRows size = 2.
		addressRows do: [:each | 
			self assert: (each atIndex: 1) = 3.
			self assert: (each atIndex: 2) = 'bar.org'].
].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadJustTheEmailAddressNotThePersonAndWriteBackWithNoChanges [
	| addresses addressRows |
	"We won't have the person object to set a value for the PERSON_ID field. Ensure that we don't write a null for that field, or otherwise modify things."
	self inTransactionDo: [	
		self writePersonWithEmailAddresses.
		session beginUnitOfWork.
		addresses := session read: GlorpEmailAddress.
		self assert: ((session privateGetCache cacheForClass: GlorpPerson) at: 3 ifAbsent: [nil]) isNil.
		session commitUnitOfWork.
		addressRows := session accessor executeSQLString: 'SELECT PERSON_ID from EMAIL_ADDRESS'.
		self assert: addressRows size = 2.
		addressRows do: [:each | self assert: (each atIndex: 1) = 3].
].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonAndAddEmailAddress [
	| |
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [person emailAddresses add: (GlorpEmailAddress new id: 99876; user: 'postmaster'; host: 'foo.com')]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId3 := 99876.
			self readPerson.
			self checkEmailAddresses: person emailAddresses].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonAndAddEmailAddressProxy [
	| address |
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| query |
					query := Query
						readOneOf: GlorpEmailAddress
						where: [:each | each id = 99876].
					query proxyType: Proxy.
					address := session execute: query.
					address yourself.
					person emailAddresses add: address.
					self assert: person emailAddresses last class == Proxy]
				initializeWith:
					[self writePersonWithEmailAddresses.
					session
						transact:
							[(GlorpEmailAddress new)
								id: 99876;
								user: 'postmaster';
								host: 'foo.com'].
						session reset].
			emailId3 := 99876.
			self readPerson.
			self checkEmailAddresses: person emailAddresses].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonAndAddEmailAddressTwice [
	| personRow addressRow |
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[person emailAddresses
						add:
							((GlorpEmailAddress new)
								id: 99876;
								user: 'postmaster';
								host: 'foo.com')]
				initializeWith:
					[addressRow := session system exampleAddressRow.
					session writeRow: addressRow.
					personRow := session system examplePersonRow1.
					personId := personRow atFieldNamed: 'ID'.
					session writeRow: personRow].
			self
				inUnitOfWorkDo:
					[person emailAddresses
						add:
							((GlorpEmailAddress new)
								id: 99991;
								user: 'someone';
								host: 'foo.com')]
				initializeWith: [].
			emailId1 := 99876.
			emailId2 := 99991.
			self readPerson.
			self checkEmailAddresses: person emailAddresses].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonAndDeleteEmailAddress [
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [
					session delete: person emailAddresses last. 
					person emailAddresses removeLast. ]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 1].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonAndRemoveEmailAddress [
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [person emailAddresses removeLast]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 2].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonAndReplaceEmailAddressesWithDifferent [
	| |
	self
		inTransactionDo:
			[self 
				inUnitOfWorkDo: [
					person emailAddresses: (Array with: (GlorpEmailAddress new id: 99876; user: 'postmaster'; host: 'foo.com')) ]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId1 := 99876.
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 3].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonAndReplaceEmailAddressesWithRemoval [
	| |
	self
		inTransactionDo:
			[self 
				inUnitOfWorkDo: [
					person emailAddresses: (Array with: person emailAddresses first) ]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 2].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonAndReplaceInstantiatedEmailAddressesWithEmpty [
	| |
	self
		inTransactionDo:
			[self 
				inUnitOfWorkDo: [
					person emailAddresses yourSelf. 
					person emailAddresses: #(). ]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId1 := nil.
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 2].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonAndReplaceUninstantiatedEmailAddressesWithEmpty [
	| |
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [person emailAddresses: #().]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId1 := nil.
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 2].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonWithEmailAddresses [
	| query result emailAddresses |
	self
		inTransactionDo:
			[self writePersonWithEmailAddresses.
			query := Query
				readOneOf: GlorpPerson
				where: [:eachPerson | eachPerson id = personId].
			result := query executeIn: session.
			emailAddresses := result emailAddresses getValue.
			self checkEmailAddresses: emailAddresses].
]

{ #category : #tests }
GlorpOneToManyDBTest >> testReadPersonWithExistsWithAlsoFetch [
	| people query |
	self inTransactionDo: 
			[self setUpSomeExtraPeople.
			query := ReadQuery read: GlorpPerson
						where: 
							[:eachPerson | 
							eachPerson emailAddresses 
								anySatisfyExists: [:eachEmail | eachEmail host = 'objectpeople.com']].
			query alsoFetch: [:e | e address].
			people := query executeIn: session.
			self assert: people size = 1]
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonWithIsEmptySubselectToEmailAddresses [
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | eachPerson emailAddresses isEmpty].
			self assert: people size = 1].
]

{ #category : #'tests-join' }
GlorpOneToManyDBTest >> testReadPersonWithJoinToEmailAddresses [
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | 
					eachPerson emailAddresses
						anySatisfyJoin: [:eachEmail | eachEmail host = 'objectpeople.com']].
			self assert: people size = 1].
]

{ #category : #tests }
GlorpOneToManyDBTest >> testReadPersonWithJoinWithAlsoFetch [
	| people query |
	self inTransactionDo: 
			[self setUpSomeExtraPeople.
			query := ReadQuery read: GlorpPerson
						where: 
							[:eachPerson | 
							eachPerson emailAddresses anySatisfyJoin: 
									[:eachEmail | 
									eachEmail host = 'objectpeople.com' | (eachEmail host = 'cs.uiuc.edu')]].
			query alsoFetch: [:e | e address].
			people := query executeIn: session.
			self assert: people size = 1]
]

{ #category : #'tests-join' }
GlorpOneToManyDBTest >> testReadPersonWithNegativeJoinToEmailAddresses [
	"Read with a negative condition. Note that this excludes the person with no e-mail addresses, as we're not doing an outer join"
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | 
					eachPerson emailAddresses
						anySatisfyJoin: [:eachEmail | eachEmail host ~= 'objectpeople.com']].
			self assert: people size = 2].
]

{ #category : #'tests-join' }
GlorpOneToManyDBTest >> testReadPersonWithNegativeSubselectToEmailAddresses [
	"Read with a negative condition. Note that this excludes the person with no e-mail addresses, as we're not doing an outer join"
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | 
					eachPerson emailAddresses
						anySatisfyExists: [:eachEmail | eachEmail host ~= 'objectpeople.com']].
			self assert: people size = 2].
]

{ #category : #'tests-read' }
GlorpOneToManyDBTest >> testReadPersonWithNotEmptySubselectToEmailAddresses [
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | eachPerson emailAddresses notEmpty].
			self assert: people size = 2].
]

{ #category : #'tests-join' }
GlorpOneToManyDBTest >> testReadPersonWithSubselectToEmailAddresses [
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | 
					eachPerson emailAddresses
						anySatisfyExists: [:eachEmail | eachEmail host = 'objectpeople.com']].
			self assert: people size = 1].
]

{ #category : #'tests-write' }
GlorpOneToManyDBTest >> testUpdatePersonWithNilEmailAddressesAndExclusiveRelationship [

	| newPerson |
	((session system descriptorFor: GlorpPerson) mappingForAttributeNamed: #emailAddresses) beExclusive.
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson new.
		newPerson id: 231.
		personId := 231.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		session modify: person in: [person emailAddresses: nil].
		session reset.
		self readPerson.
		self assert: person emailAddresses isEmpty.
		self checkNumberOfEmailAddressesInDB: 0].
]

{ #category : #'tests-write' }
GlorpOneToManyDBTest >> testWritePersonWithEmailAddresses [

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
]

{ #category : #'tests-write' }
GlorpOneToManyDBTest >> testWritePersonWithNilEmailAddresses [

	| newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson new.
		newPerson id: 231.
		personId := 231.
		newPerson emailAddresses: nil.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person emailAddresses isEmpty.
		self checkNumberOfEmailAddressesInDB: 0].
]

{ #category : #'tests-write' }
GlorpOneToManyDBTest >> testWritePersonWithNilEmailAddressesAndExclusiveRelationship [

	| newPerson |
	((session system descriptorFor: GlorpPerson) mappingForAttributeNamed: #emailAddresses) beExclusive.
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson new.
		newPerson id: 231.
		personId := 231.
		newPerson emailAddresses: nil.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person emailAddresses isEmpty.
		self checkNumberOfEmailAddressesInDB: 0].
]

{ #category : #'tests-write' }
GlorpOneToManyDBTest >> testWritePersonWithNoEmailAddresses [

	| newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson new.
		newPerson id: 231.
		personId := 231.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person emailAddresses isEmpty.
		self checkNumberOfEmailAddressesInDB: 0].
]

{ #category : #'tests-write' }
GlorpOneToManyDBTest >> testWritePersonWithNoEmailAddresses2 [

	| newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson new.
		newPerson id: 231.
		personId := 231.
		newPerson emailAddresses: OrderedCollection new.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person emailAddresses isEmpty.
		self checkNumberOfEmailAddressesInDB: 0].
]

{ #category : #support }
GlorpOneToManyDBTest >> writePersonWithEmailAddresses [
	| addressRow personRow emailAddress1Row emailAddress2Row |
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
	personRow := session system examplePersonRow1.
	personId := personRow atFieldNamed: 'ID'.
	session writeRow: personRow.
	emailAddress1Row := session system exampleEmailAddressRow1.
	emailAddress2Row := session system exampleEmailAddressRow2.
	emailId1 := emailAddress1Row at: (emailAddress1Row table fieldNamed: 'ID').
	emailId2 := emailAddress2Row at: (emailAddress2Row table fieldNamed: 'ID').
	session writeRow: emailAddress1Row.
	session writeRow: emailAddress2Row.
]
