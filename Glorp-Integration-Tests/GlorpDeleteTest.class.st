"
This tests deletions.
"
Class {
	#name : #GlorpDeleteTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'delete-insert-update tests' }
GlorpDeleteTest >> assertDeleteCopy: aBlock ofInsertUpdatesFields: anInteger [
	"If the test is run bound then #shouldUpdateOnlyChangedFields will by default return false and all 3 fields will be updated regardless of which have been changed.  We therefore check the row's opinion of fieldsNeedingUpdate, not the UpdateCommand's opinion."

	| person oldAddress address otherSession triedToWrite |
	person := GlorpPerson example2.
	person address: nil.
	[address := self setUpPersonWithAddress address getValue.
	oldAddress := aBlock value: address.
	address street: 'Change Street'.
	otherSession := GlorpDemoDescriptorSystem sessionForLogin: GlorpDatabaseLoginResource current login.
	otherSession  accessor: GlorpDatabaseLoginResource current accessor.
	otherSession accessor denyWrites.
	otherSession beginUnitOfWork.
	otherSession delete: oldAddress.
	person address: address.
	otherSession register: person.
	[otherSession commitUnitOfWork] on: GlorpIllegalCommand do:
		[:ex || rowMap row | triedToWrite := true.
		rowMap := otherSession privateGetCurrentUnitOfWork privateGetRowMap
			subMapForTable: (otherSession system tableNamed: 'GR_ADDRESS').
		row := rowMap at: address.
		self deny: row forDeletion.
		self assert: row fieldsNeedingUpdate size = anInteger.
		row := rowMap at: oldAddress.
		self assert: row forDeletion]] ensure:
			[session rollbackTransaction.
			otherSession rollbackTransaction.
			otherSession resetPermissions].
	self assert: triedToWrite.
]

{ #category : #tests }
GlorpDeleteTest >> checkCustomerDeletedInDatabase [
	| result |
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_CUSTOMER WHERE ID=1'.
	self assert: result isEmpty
]

{ #category : #tests }
GlorpDeleteTest >> checkCustomerNotInCache [
	self assert: (session cacheLookupForClass: GlorpCustomer key: 1) isNil
]

{ #category : #tests }
GlorpDeleteTest >> checkCustomerStillInCache [
	self assert: (session cacheLookupForClass: GlorpCustomer key: 1) notNil
]

{ #category : #tests }
GlorpDeleteTest >> checkFoldersDeletedInDatabase [
	| result generalResult |
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_FOLDER WHERE USER_ID=1'.
	self assert: result isEmpty.

	generalResult := session accessor 
				executeSQLString: 'SELECT * FROM GR_FOLDER'.
	self assert: generalResult size = 1.
]

{ #category : #tests }
GlorpDeleteTest >> checkFoldersExistInDatabase [
	| result |
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_FOLDER WHERE USER_ID=1'.
	self assert: result size = 2.
]

{ #category : #tests }
GlorpDeleteTest >> checkFoldersNotInCache [
	self assert: (session cacheLookupForClass: GlorpFolder key: #(1 'One')) isNil.
	self assert: (session cacheLookupForClass: GlorpFolder key: #(1 'One-A')) isNil.
]

{ #category : #tests }
GlorpDeleteTest >> checkMessagesDeletedInDatabase [
	| result generalResult |
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_MESSAGE WHERE USER_ID = 1'.
	self assert: result isEmpty.

	generalResult := session accessor 
				executeSQLString: 'SELECT * FROM GR_MESSAGE'.
	self assert: generalResult size = 1.
]

{ #category : #tests }
GlorpDeleteTest >> checkPersonDeletedInDatabase [
	| result |
	result := session accessor 
				executeSQLString: 'SELECT * FROM PERSON WHERE ID=1'.
	self assert: result isEmpty
]

{ #category : #tests }
GlorpDeleteTest >> doDeleteAndDoubleAddOfFoldersFor: user [
	| new2 removed new |
	^session
		modify: user
		in:
			[user folders do: [:each | each printString].
			removed := user folders detect: [:each | each name = 'One'].
			user folders remove: removed.
			new := GlorpFolder new name: 'One'.
			new user: user.
			user folders add: new.
			new2 := GlorpFolder new name: 'One'.
			new2 user: user.
			user folders add: new2].
]

{ #category : #support }
GlorpDeleteTest >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
]

{ #category : #tests }
GlorpDeleteTest >> setUpCustomer [
	session beginTransaction.
	session accessor 
		executeSQLStringNoResult: 'INSERT INTO GR_CUSTOMER VALUES (1,''Fred Flintstone'')'.
	^session readOneOf: GlorpCustomer where: [:each | each id = 1].
]

{ #category : #support }
GlorpDeleteTest >> setUpFolders [

	session system: (GlorpCompositeKeyDescriptorSystem forPlatform: session platform).
	session beginTransaction.
	session transact: [session register: session system example1].
	session reset.
]

{ #category : #tests }
GlorpDeleteTest >> setUpPersonWithAddress [
	session beginTransaction.
	session accessor 
		executeSQLStringNoResult: 'INSERT INTO GR_ADDRESS VALUES (2,''Paseo Montril'', ''999'')'.
	session accessor 
		executeSQLStringNoResult: 'INSERT INTO PERSON VALUES (1,''Fred Flintstone'', 2)'.
	^session readOneOf: GlorpPerson where: [:each | each id = 1].
]

{ #category : #support }
GlorpDeleteTest >> tearDown [
	super tearDown.
	session reset.
	session := nil.
]

{ #category : #tests }
GlorpDeleteTest >> testCascadingDeleteAcrossNil [
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
]

{ #category : #tests }
GlorpDeleteTest >> testCascadingDeleteInstantiating [
	| user |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session beginUnitOfWork.
	user folders do: [:each | each printString].
	session delete: user.
	session commitUnitOfWork.
	self checkFoldersNotInCache.
	self checkFoldersDeletedInDatabase.
	self checkMessagesDeletedInDatabase] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpDeleteTest >> testCascadingDeleteWithoutInstantiating [
	| user |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session beginUnitOfWork.
	session delete: user.
	session commitUnitOfWork.
	self checkFoldersNotInCache.
	self checkFoldersDeletedInDatabase] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpDeleteTest >> testDeleteAndReinsertTwiceWhenRemovingFromAnExclusiveCollection [
	"Make sure that if we add a new thing twice, we get the expected failure of a primary key conflict."

	| user |
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session
		readOneOf: GlorpUser
		where: [:each | each name = 'User One'].
	self
		should: [self doDeleteAndDoubleAddOfFoldersFor: user]
		raise: GlorpDatabaseWriteError] ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpDeleteTest >> testDeleteAndReinsertWhenRemovingFromAnExclusiveCollection [
	"Test that if we delete something and then re-insert with the same primary key, that it gets converted to an update. This is not really advisable as something to do, since you're really violating the primary key = object identity correspondence, but it can reasonably happen if you're using domain primary keys, link tables reified as objects, or other circumstances"
	| user removed result generalResult new |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session modify: user in: [
		user folders do: [:each | each printString].
		removed := user folders detect: [:each | each name = 'One'].
		user folders remove: removed.
		new := GlorpFolder new name: 'One'.
		new user: user.
		user folders add: new].
	self assert: (session cacheLookupForClass: GlorpFolder key: #(1 'One')) == new.
	result := session accessor executeSQLString: 'SELECT * FROM GR_FOLDER WHERE USER_ID=1'.
	self assert: result size = 2.

	generalResult := session accessor executeSQLString: 'SELECT * FROM GR_FOLDER'.
	self assert: generalResult size = 3.

	result := session accessor executeSQLString: 'SELECT * FROM GR_MESSAGE WHERE USER_ID = 1'.
	self assert: result isEmpty.

	generalResult := session accessor executeSQLString: 'SELECT * FROM GR_MESSAGE'.
	self assert: generalResult size = 1.] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpDeleteTest >> testDeleteFromAnExclusiveCollectionContainingNil [
	| user removed |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session modify: user in: [
		user folders do: [:each | each printString].
		removed := user folders detect: [:each | each name = 'One'].
		user folders remove: removed.
		user folders add: nil]
	"The only assertion is that we shouldn't be crashing here."
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpDeleteTest >> testDeleteKeyValCopy [
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
]

{ #category : #'delete-insert-update tests' }
GlorpDeleteTest >> testDeleteKeyValCopyInsertIsUpdate [
	"By definition, the key value(s) must be the same for the delete and insert are merged into an update.  In this test, the deleted object has no values for the two non-key fields."

	self
		assertDeleteCopy: [:addr | GlorpAddress new id: addr id; yourself]
		ofInsertUpdatesFields: 2.
]

{ #category : #tests }
GlorpDeleteTest >> testDeleteMultipleTable [
	| passengerRow1 passengerRow2 passenger rows frequentFlyerRow1 frequentFlyerRow2 |
	
	[
	session beginTransaction.
	passengerRow1 := session system examplePassengerRow.
	session writeRow: passengerRow1.
	frequentFlyerRow1 := session system exampleFrequentFlyerRow.
	session writeRow: frequentFlyerRow1.
	passengerRow2 := session system examplePassengerRow2.
	session writeRow: passengerRow2.
	frequentFlyerRow2 := session system exampleFrequentFlyerRow2.
	session writeRow: frequentFlyerRow2.
	passenger := session readOneOf: GlorpPassenger.
	session delete: passenger.
	rows := session accessor executeSQLString: 'SELECT * FROM FREQUENT_FLYER'.
	self assert: rows size = 1.
	rows := session accessor executeSQLString: 'SELECT * FROM PASSENGER'.
	self assert: rows size = 1.
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpDeleteTest >> testDeleteMultipleTableWithOneMissing [
	| passengerRow1 passengerRow2 passenger rows frequentFlyerRow2 |
	
	[
	session beginTransaction.
	passengerRow1 := session system examplePassengerRow.
	session writeRow: passengerRow1.
	passengerRow2 := session system examplePassengerRow2.
	session writeRow: passengerRow2.
	frequentFlyerRow2 := session system exampleFrequentFlyerRow2.
	session writeRow: frequentFlyerRow2.
	passenger := session readOneOf: GlorpPassenger where: [:each | each id = 1].
	session delete: passenger.
	rows := session accessor executeSQLString: 'SELECT * FROM FREQUENT_FLYER'.
	self assert: rows size = 1.
	rows := session accessor executeSQLString: 'SELECT * FROM PASSENGER'.
	self assert: rows size = 1.
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #'delete-insert-update tests' }
GlorpDeleteTest >> testDeleteOldCopyInsertNewIsUpdate [
	"This shows how a user can mimic Glorp's memento management while deferring creating a session.  You capture a shallowCopy of the object of interest, then change the original as you wish.  By deleting the old copy and registering the changed original in the same session, you achieve the same effect as if you had registered the original in the session before you changed it:  the session treats it as an update.  The user is responsible for ensuring it is, i.e. an object of that key is already in the database.  Only the changed field would be regarded as needing update by the row if the deleted row were its oldVersion, but collapseMatchingInsertsAndDeletesFor: does not set this for fear a user could carelessly provide a deleted object that matched a changed field in the inserted object, so would not be updated.  Thus all non-key fields are always updated, even when not differing between delete and insert."

	self
		assertDeleteCopy: [:addr | addr shallowCopy]
		ofInsertUpdatesFields: 2.
]

{ #category : #'delete-insert-update tests' }
GlorpDeleteTest >> testDeleteShallowCopyInsertIsUpdate [
	"This is like testDeleteOldCopyInsertNewIsUpdate but demonstrates a workaround for the case when the user knows the object is already in the database but did not capture a shallowCopy before changing it.  It exploits the Glorp shortcut that, when delete and insert are combined to update, Glorp does not check which fields have changed but updates all fields, even though in this example the object and copy are unchanged."

	| person address otherSession |
	person := GlorpPerson example2.
	person address: nil.

	[address := self setUpPersonWithAddress address getValue.
	address street: 'Change Street'.
	otherSession := GlorpDemoDescriptorSystem sessionForLogin: GlorpDatabaseLoginResource current login.
	otherSession  accessor: GlorpDatabaseLoginResource current accessor.
	otherSession beginUnitOfWork.
	otherSession delete: address shallowCopy.
	person address: address.
	otherSession register: person.
	otherSession commitUnitOfWork]
			ensure: [session rollbackTransaction.  otherSession rollbackTransaction]
]

{ #category : #tests }
GlorpDeleteTest >> testDeleteWhenRemovingFromAnExclusiveCollection [
	| user removed result generalResult |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session modify: user in: [
		user folders do: [:each | each printString].
		removed := user folders detect: [:each | each name = 'One'].
		user folders remove: removed].
	self assert: (session cacheLookupForClass: GlorpFolder key: #(1 'One')) isNil.
	result := session accessor executeSQLString: 'SELECT * FROM GR_FOLDER WHERE USER_ID=1'.
	self assert: result size = 1.

	generalResult := session accessor executeSQLString: 'SELECT * FROM GR_FOLDER'.
	self assert: generalResult size = 2.

	result := session accessor executeSQLString: 'SELECT * FROM GR_MESSAGE WHERE USER_ID = 1'.
	self assert: result isEmpty.

	generalResult := session accessor executeSQLString: 'SELECT * FROM GR_MESSAGE'.
	self assert: generalResult size = 1.] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpDeleteTest >> testDeleteWhere [

	[ self setUpCustomer.
	session inUnitOfWorkDo: [ session delete: GlorpCustomer where: [ :each | each id = 1 ] ].
	self checkCustomerDeletedInDatabase
	]
		ensure: [ session rollbackTransaction ]
]

{ #category : #tests }
GlorpDeleteTest >> testNormalDeleteOnFolders [
	| user |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session beginUnitOfWork.
	session delete: user.
	user folders do: [:each | 
		session delete: each.
		each messages do: [:eachMessage |
			session delete: eachMessage]].
	session commitUnitOfWork.
	self checkFoldersNotInCache.
	self checkFoldersDeletedInDatabase.
	self checkMessagesDeletedInDatabase] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpDeleteTest >> testUnitOfWorkDelete [
	| customer result |
	
	[customer := self setUpCustomer.
	session beginUnitOfWork.
	session delete: customer.
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_CUSTOMER WHERE ID=1'.
	self assert: result size = 1.
	self 
		assert: (session readOneOf: GlorpCustomer where: [:each | each id = 1]) isNil.
	self checkCustomerStillInCache.
	session commitUnitOfWork.
	self checkCustomerNotInCache.
	self checkCustomerDeletedInDatabase] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpDeleteTest >> testUnitOfWorkDeleteOrder [
	| person |
	
	[person := self setUpPersonWithAddress.
	session beginUnitOfWork.
	session delete: person.
	session delete: person address.
	session commitUnitOfWork.
	self checkPersonDeletedInDatabase.] 
			ensure: [session rollbackTransaction]
]
