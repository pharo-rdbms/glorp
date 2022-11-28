Class {
	#name : #GlorpOneToOneDBTest,
	#superclass : #GlorpMappingDBTest,
	#instVars : [
		'person',
		'personId'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> additionalTests [

	"It would be good to have tests here for a foreign key 'pointing' the other direction. Also composite keys (once those work)"
]

{ #category : #support }
GlorpOneToOneDBTest >> checkAddress [
	self assert: person address isGlorpProxy.
	self assert: person address getValue id = 123.
	^self assert: person address getValue class == GlorpAddress.
]

{ #category : #support }
GlorpOneToOneDBTest >> checkNoAddress [
	self deny: person address isGlorpProxy.
	self assert: person address == nil.
]

{ #category : #support }
GlorpOneToOneDBTest >> checkNoAddressesInDB [
	| addresses addressKeys |
	addresses := session accessor executeSQLString: 'SELECT * FROM GR_ADDRESS'.
	self assert: addresses isEmpty.
	addressKeys := session accessor executeSQLString: 'SELECT ADDRESS_ID FROM PERSON'.
	self assert: (addressKeys size = 1).
	self assert: (addressKeys first atIndex: 1) = nil.
]

{ #category : #support }
GlorpOneToOneDBTest >> checkPerson [
	self assert: person class = GlorpPerson.
	self assert: person id = personId.
	self assert: person name = 'aPerson'.
]

{ #category : #support }
GlorpOneToOneDBTest >> inUnitOfWorkDo: aBlock [
	"Set up a bunch of the normal data, read the objects, then run the block in a unit of work"
	self inUnitOfWorkDo: aBlock initializeWith: [self writePersonWithAddress].
]

{ #category : #support }
GlorpOneToOneDBTest >> inUnitOfWorkDo: aBlock initializeWith: initBlock [
	"Set up a bunch of the normal data, read the objects, then run the block in a unit of work"
	initBlock value.
	session beginUnitOfWork.
	self readPerson.
	aBlock value.
	session commitUnitOfWork.
	session reset.
]

{ #category : #support }
GlorpOneToOneDBTest >> readPerson [
	| results query |
	query := Query
		read: GlorpPerson
		where: [:pers | pers id = personId].
	results := query executeIn: session.
	self assert: results size = 1.
	person := results first.
]

{ #category : #'tests-link table' }
GlorpOneToOneDBTest >> testLinkTableRead [
	| customers |
	system := GlorpLinkTableAnywhereDescriptorSystem forPlatform: system platform.
	session system: system.
	self inTransactionDo: [
		self writeCustomersWithOneAccountEach.
		session reset.
		customers := session read: GlorpCustomer.
		self assert: ((customers collect: [:each | each accounts id]) asSortedCollection asArray = #(22 9874))].
]

{ #category : #'tests-link table' }
GlorpOneToOneDBTest >> testLinkTableWrite [
	system := GlorpLinkTableAnywhereDescriptorSystem
		forPlatform: system platform.
	session system: system.
	self
		inTransactionDo:
			[| rows row |
			self
				inUnitOfWorkDo:
					[| cust1 acct1 |
					cust1 := GlorpCustomer new.
					cust1 id: 2.
					cust1 name: 'Violet Baudelaire'.
					acct1 := GlorpBankAccount new.
					acct1 id: 3.
					cust1 accounts: acct1.
					session register: cust1].
			session reset.
			rows := session accessor
				executeSQLString:
					'select * from GR_CUSTOMER t1, BANK_ACCT t2, CUSTOMER_ACCT_LINK t3 WHERE t3.ACCT_ID = t2.ID AND t3.CUSTOMER_ID = t1.ID'.
			self assert: rows size = 1.
			row := rows first.
			self assert: (row asArray = (OrderedCollection new add: 2; add: 'Violet Baudelaire'; add: 3; add: nil; add: nil; add: nil; add: 2; add: 3; yourself) asArray)].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReRegisteringAfterUpdate [
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
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadAction [
	| collection |
	self
		inTransactionDo:
			[collection := OrderedCollection new.
			self writePersonWithAddress.
			((session system descriptorFor: GlorpPerson)
				mappingForAttributeNamed: #address)
				proxyAction: [:owner :object | collection add: owner -> object].
			person := session readOneOf: GlorpPerson.
			person address yourSelf.
			self assert: collection size = 1.
			self assert: collection first = (person -> person address yourSelf)].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndAddAddress [
	self inTransactionDo: [
		self 
			inUnitOfWorkDo: [person address: (GlorpAddress new id: 5555; street: 'hello'; number: 'world')]
			initializeWith: [self writeHomelessPerson].
		self readPerson.
		self checkPerson].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndAddBogusCollectionInsteadOfAddress [
	self inTransactionDo: [
		self should: [self 
				inUnitOfWorkDo: [person address: #()]
				initializeWith: [self writeHomelessPerson]]
			raise: GlorpInvalidTypeError].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndAddBogusObjectInsteadOfAddress [
	self inTransactionDo: [
		self should: [self 
				inUnitOfWorkDo: [person address: GlorpPerson new]
				initializeWith: [self writeHomelessPerson]]
			raise: GlorpInvalidTypeError].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndAddBogusObjectInsteadOfEmailAddresses [
	self inTransactionDo: [
		self should: [self 
				inUnitOfWorkDo: [person emailAddresses: 42]
				initializeWith: [self writeHomelessPerson]]
			raise: GlorpInvalidTypeError].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndAddBogusObjectInsteadOfEmailAddresses2 [
	self inTransactionDo: [
		self should: [self 
				inUnitOfWorkDo: [person emailAddresses: GlorpEmailAddress new]
				initializeWith: [self writeHomelessPerson]]
			raise: GlorpInvalidTypeError].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndRemoveAddress [
	self inTransactionDo: [
		self inUnitOfWorkDo: [
			session delete: person address.
			person address: nil.].
		self readPerson.
		self checkPerson.
		self checkNoAddress.
		self checkNoAddressesInDB].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndReplaceAddress [
	self inTransactionDo:
		[self inUnitOfWorkDo:
			[person address: ((GlorpAddress new) id: 12; street: 'foo'; number: '1234')].
		self readPerson.
		self checkPerson.
		self assert: person address isGlorpProxy.
		self assert: person address getValue id = 12.
		self assert: person address getValue street = 'foo'.].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndReplaceAdressWithDifferentProxy [
	| proxy |
	self inTransactionDo: 
			[
			session writeRow: session system exampleAddressRowForOrdering1.
			self inUnitOfWorkDo: 
					[ | field |
					proxy := Proxy new.
					proxy query: person address query copy.
					field := (session system tableNamed: 'PERSON') fieldNamed: 'ADDRESS_ID'.
					proxy parameters: (IdentityDictionary new at: field put: 1; yourself).
					proxy session: person address session.
					person address: proxy].
			self readPerson.
			self checkPerson.
			self assert: person address isGlorpProxy.
			self assert: person address getValue notNil.
			self assert: person address getValue id = 1]
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndReplaceAdressWithProxy [
	| proxy |
	self inTransactionDo: 
			[self inUnitOfWorkDo: 
					[proxy := Proxy new.
					proxy query: person address query copy.
					proxy parameters: person address parameters copy.
					proxy session: person address session.
					person address: proxy].
			self readPerson.
			self checkPerson.
			self assert: person address isGlorpProxy.
			self assert: person address getValue notNil.
			self assert: person address getValue id = 123]
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonAndUpdateName [
	"Test to make sure that if we never instantiate the address, we don't have problems with that relationship."

	self inTransactionDo:
		[self inUnitOfWorkDo: [person name: 'new name'].
		self deny: person address isInstantiated.
		session reset.
		self readPerson.
		self assert: person name = 'new name'.
		self assert: person address isGlorpProxy.
		self assert: person address getValue id = 123.
		self assert: person address getValue street = 'Paseo Montril'].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonWithAddress [
	self inTransactionDo: [
		self writePersonWithAddress.
		self readPerson.
		self checkPerson.
		self checkAddress].
]

{ #category : #'tests-join' }
GlorpOneToOneDBTest >> testReadPersonWithJoinToAddress [
	| people |
	self inTransactionDo: [
		self writePersonWithAddress.
		people := session read: GlorpPerson where: [:eachPerson | eachPerson address street = 'Paseo Montril'].
		self assert: people size = 1.
		person := people first.
		self assert: person address street = 'Paseo Montril'.
		self assert: person address id = 123].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadPersonWithoutAddress [
	self inTransactionDo: [
		self writeHomelessPerson.
		self writeAddress.
		self readPerson.
		self checkPerson.
		self checkNoAddress].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadWithCacheHitFromExpression [
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[self assert: person address yourSelf id = 123.
					session accessor permitNothing.
					session readOneOf: GlorpAddress where: [:each | each id = 123]]].
]

{ #category : #'tests-read' }
GlorpOneToOneDBTest >> testReadWithCacheHitFromJoin [
	self inTransactionDo: [
		self 
			inUnitOfWorkDo: [
				session readOneOf: GlorpAddress.
				session accessor permitNothing.
				self assert: (person address yourSelf id = 123)]].
]

{ #category : #'tests-write' }
GlorpOneToOneDBTest >> testWritePersonWithAddress [
	|newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson example1.
		personId := newPerson id.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person id = newPerson id.
		self assert: person name = newPerson name.
		self assert: person address id = newPerson address id.
		self assert: person address street = newPerson address street].
]

{ #category : #'tests-write' }
GlorpOneToOneDBTest >> testWritePersonWithoutAddress [
	|newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson example1.
		newPerson address: nil.
		personId := newPerson id.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person id = newPerson id.
		self assert: person name = newPerson name.
		self assert: person address yourSelf == nil.
		self checkNoAddressesInDB].
]

{ #category : #support }
GlorpOneToOneDBTest >> writeAddress [
	| addressRow |
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
]

{ #category : #'tests-link table' }
GlorpOneToOneDBTest >> writeCustomersWithOneAccountEach [
	| customerRow accountRow1 accountRow2 linkRow1 linkRow2 customerRow2 |

	customerRow := session system exampleCustomerRow1.
	customerRow2 := session system exampleCustomerRow2.
	accountRow1 := session system exampleAccountRow1. 
	accountRow2 := session system exampleAccountRow3.
	linkRow1 := session system exampleCALinkRow1.
	linkRow2 := session system exampleCALinkRow3.
	session writeRow: customerRow.
	session writeRow: customerRow2.
	session writeRow: accountRow1.
	session writeRow: accountRow2.
	session writeRow: linkRow1.
	session writeRow: linkRow2.
]

{ #category : #support }
GlorpOneToOneDBTest >> writeHomefulPerson [
	| personRow |
	personRow := session system examplePersonRow1.
	session writeRow: personRow.
	personId := personRow atFieldNamed: 'ID'.
]

{ #category : #support }
GlorpOneToOneDBTest >> writeHomelessPerson [
	| personRow |
	personRow := session system examplePersonRow2.
	session writeRow: personRow.
	personId := personRow atFieldNamed: 'ID'.
]

{ #category : #support }
GlorpOneToOneDBTest >> writePersonWithAddress [
	self writeAddress.
	self writeHomefulPerson.
]
