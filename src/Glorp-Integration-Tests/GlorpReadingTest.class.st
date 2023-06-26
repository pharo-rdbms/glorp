"
This tests the full reading mechanism, writing out some rows manually and then doing various read operations.

Instance Variables:
	session	<Session>	
	system	<GlorpDemoDescriptorSystem>	


"
Class {
	#name : #GlorpReadingTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'system',
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #resources }
GlorpReadingTest class >> resources [

	^Array with: GlorpSessionResource with: GlorpDemoTablePopulatorResource.
]

{ #category : #support }
GlorpReadingTest >> checkExpiryTime [
	""
	| rowToWrite address modifiedRow expiryTime newExpiryTime |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	expiryTime := ((session cacheFor: address) basicAt: 123 ifAbsent: [#(nil)]) at: 1.
	modifiedRow := session system exampleModifiedAddressRow.
	modifiedRow owner: address. "Otherwise it thinks it's an insert"
	session writeRow: modifiedRow.
	(Delay forSeconds: 1) wait.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	newExpiryTime := ((session cacheFor: address) basicAt: 123 ifAbsent: [#(nil)]) at: 1.
	self assert: newExpiryTime > expiryTime.
	self assert: address street = 'Paseo Montril'] 
			ensure: [session rollbackTransaction].
]

{ #category : #support }
GlorpReadingTest >> checkExpiryTime: aBlock [
	""
	| rowToWrite address modifiedRow expiryTime newExpiryTime |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	expiryTime := ((session cacheFor: address) basicAt: 123 ifAbsent: [#(nil)]) at: 1.
	modifiedRow := session system exampleModifiedAddressRow.
	modifiedRow owner: address. "Otherwise it thinks it's an insert"
	session writeRow: modifiedRow.
	(Delay forSeconds: 1) wait.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	newExpiryTime := ((session cacheFor: address) basicAt: 123 ifAbsent: [#(nil)]) at: 1.
	aBlock value: expiryTime value: newExpiryTime value: address] 
			ensure: [session rollbackTransaction].
]

{ #category : #support }
GlorpReadingTest >> checkRefreshDoing: aBlock [
	"Check that we refresh correctly doing the action specified by aBlock"
	| rowToWrite address modifiedRow |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	modifiedRow := session system exampleModifiedAddressRow.
	modifiedRow owner: address. "Otherwise it thinks it's an insert"
	session writeRow: modifiedRow.
	aBlock value: address.
	self assert: address street = 'Something Else'.] 
			ensure: [session rollbackTransaction].
]

{ #category : #support }
GlorpReadingTest >> helperForTestReadEmbeddedOneToOne [
	| transRow query result |
	
	[session beginTransaction.
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.
	query := Query readOneOf: GlorpBankTransaction
				where: [:each | each id = each id].
	result := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: result serviceCharge notNil.
	self assert: result serviceCharge description = 'additional overcharge'.
	self assert: result amount currency = #CDN.
	self assert: result amount amount = 7.
	self assert: result serviceCharge amount currency = #USD.
	self assert: result serviceCharge amount amount = 2.
	^result.
]

{ #category : #accessing }
GlorpReadingTest >> session [
	^session.
]

{ #category : #accessing }
GlorpReadingTest >> session: anObject [
	session := anObject
]

{ #category : #running }
GlorpReadingTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession.
	system := session system
]

{ #category : #running }
GlorpReadingTest >> tearDown [

	session reset.
	session := nil.
	system := nil.
	super tearDown
]

{ #category : #tests }
GlorpReadingTest >> testCompoundAND [
	| object query results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpAddress
				where: [:address | address id < 124 AND: (address id  > 122) AND: (address id ~= nil)].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'
]

{ #category : #tests }
GlorpReadingTest >> testConversionOnConstantQueryParams [
	| query result transRow | 
	
	[
	session beginTransaction.
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.
	query := Query read: GlorpBankTransaction where: [:trans | trans amount currency = #CDN].
	result := session execute: query.
	self assert: result size = 1.
	self assert: result first amount amount = 7] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testConversionOnConstantQueryParams2 [
	| query result transRow |
	
	[
	session beginTransaction.
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.
	query := Query read: GlorpBankTransaction where: [:trans | trans amount amount = 7].
	result := session execute: query.
	self assert: result size = 1.
	self assert: result first amount amount = 7] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testCount [
	| query result account extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.


	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each id count].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = 3.
	account := result first] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testCountOnRelatedAttribute [
	| query result account extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.


	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountHolders id count].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = 2.
	account := result first] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testCountStar [
	| query result account extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.


	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each countStar].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = 3.
	account := result first] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testCountStarInRetrieveWithConstants [
	| query result account extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.


	query := Query read: GlorpBankAccount.
	query session: session.
	query retrieve: [:each | each countStar].
	query retrieve: [:each | 'X'].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = #(3 'X').
	account := result first] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testCountStarOnRelatedObject [
	| query result account extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountHolders countStar].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = 2.
	account := result first] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testCountStarOnRelatedObjectAttribute [
	| query result account extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.


	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountHolders id countStar].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = 2.
	account := result first] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testCountStarOnRelatedObjectWithGroupBy [
	| query result extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountHolders countStar].
	query groupBy: [:each | each id].
	result := query executeIn: session.
	self assert: result = #(1 1 )] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-sql' }
GlorpReadingTest >> testCustomSQLInAccountsMapping [
	"Test using custom sql for the mapping's query. This will only work if using binding."

	| query id1 id2 result accounts backRef1 backRef2 accountIds |
	session useBinding ifFalse: [^self].
	((session system descriptorFor: GlorpCustomer) 
		mappingForAttributeNamed: #accounts)
			query sql: 'SELECT t1.ID, t1.BANK_CODE, t1.BRANCH_NO, t1.ACCT_NO
 FROM BANK_ACCT t1, CUSTOMER_ACCT_LINK t2
 WHERE ((t2.ACCT_ID = t1.ID) AND (t2.CUSTOMER_ID = ?))'.
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	id1 := accountIds at: 1.
	id2 := accountIds at: 2.
	query := Query readOneOf: GlorpCustomer
				where: [:person | person id = 27].
	result := session execute: query.
	accounts := result accounts getValue.
	self assert: accounts size = 2.
	self assert: (accounts first id = id1 or: [accounts last id = id1]).
	self assert: (accounts first id = id2 or: [accounts last id = id2]).
	self assert: accounts first id ~= accounts last id.
	backRef1 := accounts first accountHolders getValue.
	self assert: backRef1 size = 1.
	self assert: backRef1 first = result.
	backRef2 := accounts first accountHolders getValue.
	self assert: backRef2 size = 1.
	self assert: backRef2 first = result] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-sql' }
GlorpReadingTest >> testCustomSQLInAddressMapping [
	| object query results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpAddress.
	query sql: 'select id, street, house_num from GR_ADDRESS where id = 123'.
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'
]

{ #category : #tests }
GlorpReadingTest >> testDeleteWithEmbedded [
	| transaction uow |
	
	[session beginTransaction.
	session beginUnitOfWork.
	self writeCustomer1RowsWithTransactions.
	transaction := (session read: GlorpBankTransaction) first.
	session delete: transaction.
	uow := session privateGetCurrentUnitOfWork.
	self assert: (uow willDelete: transaction).
	self assert: (uow willDelete: transaction amount).
	self assert: (uow willDelete: transaction serviceCharge).
	self assert: (uow willDelete: transaction serviceCharge amount).
	session commitUnitOfWork] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testDeletedObjectsNotReadInManyQuery [
	| query anAccount accounts someAccountId |
	[session beginTransaction.
	someAccountId := self writeCustomer1Rows first.
	session beginUnitOfWork.
	query := Query readOneOf: GlorpBankAccount
				where: [:each | each id = someAccountId].
	anAccount := session execute: query.
	self assert: anAccount class == GlorpBankAccount.
	self assert: anAccount id = someAccountId.
	session delete: anAccount.
	accounts := session read: GlorpBankAccount.
	self assert: accounts size = 1.
	self deny: (accounts includes: anAccount).
	self deny: (accounts anySatisfy: [:each | each id = someAccountId]).
] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testDeletedObjectsNotReadInOneQuery [
	| query anAccount someAccountId account |
	[session beginTransaction.
	someAccountId := self writeCustomer1Rows first.
	session beginUnitOfWork.
	query := Query readOneOf: GlorpBankAccount
				where: [:each | each id = someAccountId].
	anAccount := session execute: query.
	self assert: anAccount class == GlorpBankAccount.
	self assert: anAccount id = someAccountId.
	session delete: anAccount.
	account := session readOneOf: GlorpBankAccount where: [:each | each id = someAccountId].
	self assert: account isNil] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testExpiryTimeNotReset [
	| cachePolicy |
	cachePolicy := TimedExpiryCachePolicy new.
	cachePolicy timeoutSeconds: 3.
	cachePolicy expiryAction: #refresh.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkExpiryTime: [:expiryTime :newExpiryTime :address | 
		self assert: newExpiryTime = expiryTime.
		self assert: address street = 'Paseo Montril'].
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testExpiryTimeReset [
	| cachePolicy |
	cachePolicy := TimedExpiryCachePolicy new.
	cachePolicy timeoutSeconds: 4.
	cachePolicy expiryAction: #remove.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkExpiryTime: [:expiryTime :newExpiryTime :address | 
		self assert: newExpiryTime > expiryTime.
		self assert: address street = 'Paseo Montril'].
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testExpiryTimeReset2 [
	| cachePolicy |
	cachePolicy := TimedExpiryCachePolicy new.
	cachePolicy timeoutSeconds: 4.
	cachePolicy expiryAction: #notifyAndRemove.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkExpiryTime: [:expiryTime :newExpiryTime :address | 
		self assert: newExpiryTime > expiryTime.
		self assert: address street = 'Paseo Montril'].
]

{ #category : #'tests-in' }
GlorpReadingTest >> testInFromJoin [
	| query result |
	[session beginTransaction.
	self writeReservationData.
	query := Query read: GlorpItinerary where: [:each | each reservation passengers 
		anySatisfyJoin: [:eachPassenger | eachPassenger airline id in: #(73 74)]].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | each reservation passengers anySatisfy: [:eachPassenger | #(73 74) includes: eachPassenger airline id]]).
	self assert: result size = 2] ensure: [session rollbackTransaction].
]

{ #category : #'tests-in' }
GlorpReadingTest >> testInFromSubselect [
	| query result |
	[session beginTransaction.
	self writeReservationData.
	query := Query read: GlorpItinerary where: [:each | each reservation passengers 
		anySatisfyExists: [:eachPassenger | eachPassenger airline id in: #(73 74)]].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | each reservation passengers anySatisfy: [:eachPassenger | #(73 74) includes: eachPassenger airline id]]).
	self assert: result size = 2] ensure: [session rollbackTransaction].
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testMax [
	| query result account |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountNumber accountNumber max].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = '4'.
	account := result first] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testMin [
	| query result account |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountNumber accountNumber min].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = '3'.
	account := result first] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testNonIntrusiveAlsoFetch [
	| alsoFetchQuery query results | 

	"If a platform has no outer joins (!) we cannot execute
	 this test."
	(session system platform supportsANSIJoins or: [
		session system platform useMicrosoftOuterJoins or: [
		session system platform useOracleOuterJoins ]])
			ifFalse: [ ^self ].

	[session beginTransaction.
	session beginUnitOfWork.
	session register: GlorpPerson example1.
	session register: (GlorpPerson example1
							id: 2;
							address: nil;
							yourself).
	session commitUnitOfWork.
	alsoFetchQuery := Query
						read: GlorpPerson
						where: nil.
	alsoFetchQuery alsoFetch: [:ea | ea address asOuterJoin].
	query := Query
					read: GlorpPerson
					where: nil.
	results := alsoFetchQuery executeIn: session.
	self assert: results size = 2.
	results := query executeIn: session.
	self assert: results size = 2] 
			ensure: [session rollbackTransaction].
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testNonRefreshAddress [
	"Test that if we don't set the refresh flag on the query we don't re-read the data"
	| query rowToWrite address modifiedRow |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	modifiedRow := session system exampleModifiedAddressRow.
	modifiedRow owner: address. "Otherwise it thinks it's an insert"
	session writeRow: modifiedRow.
	query := Query readOneOf: GlorpAddress where: [:each | each id = 123].
	query executeIn: session.
	self assert: address street = 'Paseo Montril'.] 
			ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpReadingTest >> testQueryHasLimit [
	self deny: (SimpleQuery read: GlorpAddress) hasLimit.
	self assert: (SimpleQuery read: GlorpAddress limit: 10) hasLimit.
	self assert: (SimpleQuery read: GlorpAddress limit: -10) hasLimit.

	self assert: (SimpleQuery read: GlorpAddress) limitMakesSense.
	self assert: (SimpleQuery read: GlorpAddress limit: 10) limitMakesSense.
	self deny: (SimpleQuery read: GlorpAddress limit: 0) limitMakesSense.
	self deny: (SimpleQuery read: GlorpAddress limit: -10) limitMakesSense.
]

{ #category : #tests }
GlorpReadingTest >> testQueryHasOffset [
	self deny: (SimpleQuery read: GlorpAddress) hasOffset.
	self assert: ((SimpleQuery read: GlorpAddress) offset: 10; yourself) hasOffset.
	self deny: ((SimpleQuery read: GlorpAddress) offset: 0; yourself) hasOffset.
	self deny: ((SimpleQuery read: GlorpAddress) offset: -10; yourself) hasOffset.
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithCompoundAnySatisfyExists [
	| query result |
	
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			account accountHolders anySatisfyExists: [:each | (each id = 27) & (each name = 'aCustomer')]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithCompoundAnySatisfyJoin [
	| query result |
	
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			account accountHolders anySatisfyJoin: [:each | (each id = 27) & (each name = 'aCustomer')]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithMultipleAnySatisfyExists [
	| query result |
	 
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			(account accountHolders anySatisfyExists: [:each | each id = 24]) 
				| (account accountHolders anySatisfyExists: [:each | each id = 27])].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithMultipleAnySatisfyJoin [
	| query result |
	 
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			(account accountHolders anySatisfyJoin: [:each | each id = 24]) 
				| (account accountHolders anySatisfyJoin: [:each | each id = 27])].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithMultipleAnySatisfyMixed1 [
	| query result |
	 
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			(account accountHolders anySatisfyJoin: [:each | each id = 24]) 
				| (account accountHolders anySatisfyExists: [:each | each id = 27])].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithMultipleAnySatisfyMixed2 [
	| query result |
	 
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			(account accountHolders anySatisfyExists: [:each | each id = 24]) 
				| (account accountHolders anySatisfyJoin: [:each | each id = 27])].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithNestedAnySatisfyExists [
	| query result |
	[| block |
	session beginTransaction.
	self writeCustomer1RowsWithTransactions.
	block := 
			[:account | 
			account accountHolders anySatisfyExists: [:each | each transactions anySatisfyExists: [:eachTrans |
			eachTrans id ~= nil]]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithNestedAnySatisfyJoin [
	| query result |
	[| block |
	session beginTransaction.
	self writeCustomer1RowsWithTransactions.
	block := 
			[:account | 
			account accountHolders anySatisfyJoin: [:each | each transactions anySatisfyJoin: [:eachTrans |
			eachTrans id ~= nil]]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithNestedAnySatisfyMixed1 [
	| query result |
	[| block |
	session beginTransaction.
	self writeCustomer1RowsWithTransactions.
	block := 
			[:account | 
			account accountHolders anySatisfyExists: [:each | each transactions anySatisfyJoin: [:eachTrans |
			eachTrans id ~= nil]]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithNestedAnySatisfyMixed2 [
	| query result |
	[| block |
	session beginTransaction.
	self writeCustomer1RowsWithTransactions.
	block := 
			[:account | 
			account accountHolders anySatisfyJoin: [:each | each transactions anySatisfyExists: [:eachTrans |
			eachTrans id ~= nil]]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAccountsWithVirtualCollectionAndAlsoFetch [
	| query result |
	 
	[| block |
	((session system descriptorFor: GlorpBankAccount) mappingForAttributeNamed: #accountHolders) collectionType: GlorpVirtualCollection.
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			(account accountHolders anySatisfyExists: [:each | each id = 24]) 
				| (account accountHolders anySatisfyJoin: [:each | each id = 27])].
	query := Query read: GlorpBankAccount where: block.
	query alsoFetch: #accountHolders.
	result := session execute: query.
	self assert: result size = 2.
	self assert: result first accountHolders class == OrderedCollection] 
			ensure: [
				((session system descriptorFor: GlorpBankAccount) mappingForAttributeNamed: #accountHolders) collectionType: OrderedCollection.
				session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAdHoc [ 
	| queryTime table row time idField times |
	
	[
	session beginTransaction.
	
	table := session system tableNamed: 'TRANSFORMED_TIME'.
	row := DatabaseRow newForTable: table.
	idField := (table fieldNamed: 'ID').
	row at: idField put: 3.
	time := Time now.
	row at: (table fieldNamed: 'TIMEFIELD') put: time asSeconds.

	session writeRow: row.
	queryTime := GlorpTransformedTime  new id: 3; time: time.
	times := session read: GlorpTransformedTime where: [:each | each time = time].
	self assert: times size = 1.
	self assert: times first time asSeconds = time asSeconds.
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAdHocProxied [
	| table row time idField times time2 |
	((session system descriptorFor: GlorpTransformedTime) mappingForAttributeNamed: #time) shouldProxy: true.
	[
	session beginTransaction.
	
	table := session system tableNamed: 'TRANSFORMED_TIME'.
	row := DatabaseRow newForTable: table.
	idField := (table fieldNamed: 'ID').
	row at: idField put: 3.
	time := Time now.
	row at: (table fieldNamed: 'TIMEFIELD') put: time asSeconds.
	session writeRow: row.

	row := DatabaseRow newForTable: table.
	row at: idField put: 4.
	time2 := Dialect addSeconds: 10 to: Time now.
	row at: (table fieldNamed: 'TIMEFIELD') put: time2 asSeconds.
	session writeRow: row.

	times := session read: GlorpTransformedTime orderBy: [:each | each time].
	self assert: times size = 2.
	self assert: times first time class == AdHocProxy.
	self assert: times first time asSeconds = time asSeconds.
	self assert: times last time asSeconds = time2 asSeconds.
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadAddress [
	| object query results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpAddress
				where: [:address | address id = 123].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'
]

{ #category : #tests }
GlorpReadingTest >> testReadAddressProxy [
	| object query results rowToWrite proxy | 

	[session beginTransaction.
		rowToWrite := session system exampleAddressRow.
		session writeRow: rowToWrite.
		query := (Query
			read: GlorpAddress
			where: ([:address | address id = 123]) ) returnProxies: true.
		results := query executeIn: session.
		self assert: (results size = 1).
		proxy := results first.
		object := proxy getValue]
	ensure: [session rollbackTransaction].

	self assert: (proxy isGlorpProxy).
	self assert: (object class = GlorpAddress).
	self assert: (object id = 123).
	self assert: (object street = 'Paseo Montril').
	self assert: (object number = '10185').
]

{ #category : #tests }
GlorpReadingTest >> testReadAddressProxyAlreadyInMemory [
	"Check that if the object is already in memory we don't create a proxy for it, just return the instance Unless explicitly asked, in which case we return a proxy."
	| object object2 query results rowToWrite |

	[session beginTransaction.
		rowToWrite := session system exampleAddressRow.
		session writeRow: rowToWrite.
		object := session readOneOf: GlorpAddress where: [:address | address id = 123].
		self deny: (object class inheritsFrom: Proxy).
		object2 := session readOneOf: GlorpAddress where: [:address | address id = 123].
		self deny: (object class inheritsFrom: Proxy).
		self assert: object2 == object.
		object := nil.
		object2 := nil.
		Dialect garbageCollect.
		(Delay forSeconds: 2) wait.
		query := (Query
			read: GlorpAddress
			where: ([:address | address id = 123]) ) returnProxies: true.
		results := query executeIn: session.
		session accessor denyReads.
		self assert: (results size = 1).
		object := results first]
	ensure: [session rollbackTransaction].

	self assert: (object class = Proxy).
	self deny: object isInstantiated.
	self assert: (object id = 123).
	self assert: (object street = 'Paseo Montril').
	self assert: (object number = '10185').
	session accessor permitEverything.
]

{ #category : #tests }
GlorpReadingTest >> testReadAddressSubstring [
	| object query results rowToWrite results2 |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpAddress
				where: [:address | (address street copyFrom: 1 to: 5) = 'Paseo'].
	results := query executeIn: session.
	query := Query read: GlorpAddress
				where: [:address | (address street copyFrom: 7 to: 13) = 'Montril'].
	results2 := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'.
	self assert: results2 size = 1.
	self assert: results2 first = results first.
]

{ #category : #'tests-sql' }
GlorpReadingTest >> testReadAddressWithCustomSQL [
	| object query results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpAddress.
	query sql: 'select id, street, house_num from GR_ADDRESS where id = 123'.
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'
]

{ #category : #'tests-sql' }
GlorpReadingTest >> testReadAddressWithCustomSQLBinding [
	"Test that we can bind to custom SQL. If not binding, don't run this test."
	| object query results rowToWrite |
	
	session useBinding ifFalse: [^self].
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpAddress.
	query sql: 'select id, street, house_num from gr_address where id = ?'.
	results := query executeWithParameters: #(123) in: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'
]

{ #category : #tests }
GlorpReadingTest >> testReadAllAddress [
	| object results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	results := session read: GlorpAddress] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'
]

{ #category : #tests }
GlorpReadingTest >> testReadCompressedMoney [
	| object query results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleCompressedMoneyRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpCompressedMoney
				where: [:money | money id ~= 0].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpCompressedMoney.
	self assert: object amount = 12.
	self assert: object currency = 'CDN'.
]

{ #category : #tests }
GlorpReadingTest >> testReadCompressedMoney2 [
	| object query results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleCompressedMoneyRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpCompressedMoney
				where: [:money | money = (GlorpCompressedMoney new id: 123; currency: 'CDN'; amount: 12)].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpCompressedMoney.
	self assert: object amount = 12.
	self assert: object currency = 'CDN'.
]

{ #category : #tests }
GlorpReadingTest >> testReadCustomerAndAddTransaction [
	| query  customer accountIds newCustomer rawRows |
	
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	session beginUnitOfWork.
	query := Query readOneOf: GlorpCustomer
				where: [:person | person id = 27].
	customer := session execute: query.
	customer addTransaction: GlorpBankTransaction example1.
	session commitUnitOfWork.
	newCustomer := session execute: query.
	self assert: customer == newCustomer.
	self assert: customer transactions first owner yourSelf == customer.
	rawRows := session accessor executeSQLString: 'SELECT ID, NAME FROM GR_CUSTOMER'.
	self assert: rawRows size = 1.
	self assert: (rawRows first atIndex: 1) = 27.
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadCustomerWithAccounts [
	| query id1 id2 result accounts backRef1 backRef2 accountIds |
	
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	id1 := accountIds at: 1.
	id2 := accountIds at: 2.
	query := Query readOneOf: GlorpCustomer
				where: [:person | person id = 27].
	result := session execute: query.
	self assert: result seenPostFetch = true.
	accounts := result accounts getValue.
	self assert: accounts size = 2.
	self assert: (accounts first id = id1 or: [accounts last id = id1]).
	self assert: (accounts first id = id2 or: [accounts last id = id2]).
	self assert: accounts first id ~= accounts last id.
	backRef1 := accounts first accountHolders getValue.
	self assert: backRef1 size = 1.
	self assert: backRef1 first = result.
	backRef2 := accounts first accountHolders getValue.
	self assert: backRef2 size = 1.
	self assert: backRef2 first = result] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadCustomerWithAnySatisfyExists [
	| query result accounts |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	query := Query read: GlorpCustomer
				where: 
					[:person | 
					person accounts anySatisfyExists: [:each | each accountNumber branchNumber > 0]].
	result := session execute: query.
	self assert: result size = 1.
	accounts := result first accounts getValue.
	self assert: accounts size = 2.
	query := Query read: GlorpCustomer
				where: 
					[:person | 
					person accounts anySatisfy: [:each | each accountNumber branchNumber = 2]].
	result := session execute: query.
	self assert: result size = 1.
	accounts := result first accounts getValue.
	self assert: accounts size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadCustomerWithAnySatisfyJoin [
	| query result accounts |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	query := Query read: GlorpCustomer
				where: 
					[:person | 
					person accounts anySatisfyJoin: [:each | each accountNumber branchNumber > 0]].
	result := session execute: query.
	self assert: result size = 1.
	accounts := result first accounts getValue.
	self assert: accounts size = 2.
	query := Query read: GlorpCustomer
				where: 
					[:person | 
					person accounts anySatisfy: [:each | each accountNumber branchNumber = 2]].
	result := session execute: query.
	self assert: result size = 1.
	accounts := result first accounts getValue.
	self assert: accounts size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadCustomerWithIncludes [
	| query result accounts account |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	account := session readOneOf: GlorpBankAccount where: [:each | each accountNumber branchNumber = 2].
	query := Query read: GlorpCustomer
				where: 
					[:person | 
					person accounts includes: account].
	result := session execute: query.
	self assert: result size = 1.
	accounts := result first accounts getValue.
	self assert: (accounts includes: account).
	self assert: accounts size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadCustomerWithMultipleAnySatisfyExists [
	| query result |
	
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:person | 
			(person accounts anySatisfyExists: [:each | each accountNumber branchNumber = 2]) 
				& (person accounts 
						anySatisfyExists: [:each | each accountNumber branchNumber = 3])].
	query := Query read: GlorpCustomer where: block.
	result := session execute: query.
	self assert: result size = 1] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadCustomerWithMultipleAnySatisfyJoin [
	| query result |
	
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:person | 
			(person accounts anySatisfyJoin: [:each | each accountNumber branchNumber = 2]) 
				& (person accounts 
						anySatisfyJoin: [:each | each accountNumber branchNumber = 3])].
	query := Query read: GlorpCustomer where: block.
	result := session execute: query.
	self assert: result size = 1] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadEmbeddedObjectDirectly [
	| serviceCharges transRow |
	
	[
	session beginTransaction.
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.
	transRow := session system exampleBankTransactionRow2.
	session writeRow: transRow.
	serviceCharges := session read: GlorpServiceCharge.
	self assert: serviceCharges size = 2.
	self deny: serviceCharges first == serviceCharges last.
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadEmbeddedOneToOne [

	self helperForTestReadEmbeddedOneToOne.
]

{ #category : #tests }
GlorpReadingTest >> testReadMultiFieldAdHoc [
	| object query results rowToWrite row2 |
	
	[session beginTransaction.
	rowToWrite := session system exampleCompressedMoneyRow.
	row2 := session system exampleCompressedMoneyRow2.
	session writeRow: rowToWrite.
	session writeRow: row2.

	query := Query read: GlorpCompressedMoney
				where: [:money | money array = #('CDN' 12)].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpCompressedMoney.
	self assert: object amount = 12.
	self assert: object currency = 'CDN'.
]

{ #category : #tests }
GlorpReadingTest >> testReadMultipleObjectsManyToMany1 [
	| query result account |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpBankAccount.
	query alsoFetch: [:each | each accountHolders].
	result := query executeIn: session.
	self assert: result size = 2.
	account := result first.
	self deny: account accountHolders isGlorpProxy.
	self assert: account accountHolders size = 1.
	self assert: (account accountHolders first == (result last accountHolders first))] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadMultipleObjectsManyToMany2 [
	| query result customer |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpCustomer.
	query retrieve: [:each | each ].
	query alsoFetch: [:each | each accounts].
	result := query executeIn: session.
	self assert: result size = 1.
	customer := result first.
	self deny: customer accounts class isGlorpProxy.
	self assert: customer accounts size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadMultipleObjectsManyToMany3 [
	| query result customer array |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpCustomer.
	query retrieve: [:each | each ].
	query retrieve: [:each | each accounts].
	result := query executeIn: session.
	self assert: result size = 1.
	array := result first.
	customer := array first.
	self deny: customer accounts isGlorpProxy.
	self assert: customer accounts size = 2.
	self assert: customer accounts == array last] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadMultipleObjectsManyToMany4 [
	"If we read just a to-many relation, then it doesn't get knitted and we just get a collection of the target"
	| query result |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpCustomer where: [:each | each id ~= 7].
	query retrieve: [:each | each accounts].
	result := query executeIn: session.
	self assert: result size = 2.
	self assert: session privateGetCache numberOfElements = 2.
	self assert: (result allSatisfy: [:each | each class == GlorpBankAccount]).
	self assert: result first ~= result last] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadMultipleObjectsToManyAlsoFetchTwoLevels [
	| query result account transactions |
	
	[session beginTransaction.
	self write2CustomerRowsWith3Transactions.
	session beginUnitOfWork.

	query := Query read: GlorpBankAccount.
	query alsoFetch: [:each | each accountHolders].
	query alsoFetch: [:each | each accountHolders transactions].
	result := query executeIn: session.
	self assert: result size = 2.
	account := result detect: [:each | each id = 9874].
	self deny: result first == result last.
	self deny: account accountHolders isGlorpProxy.
	self assert: account accountHolders size = 1.
	transactions := account accountHolders first transactions.
	self deny: transactions isGlorpProxy.
	self assert: transactions size = 2.
	self assert: account accountHolders first == (result at: 2) accountHolders first] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadPassenger [
	| passengerRow1 passengerRow2 query result |
	
	[session beginTransaction.
	passengerRow1 := session system examplePassengerRow.
	session writeRow: passengerRow1.
	passengerRow2 := session system exampleFrequentFlyerRow.
	session writeRow: passengerRow2.
	query := Query readOneOf: GlorpPassenger
				where: [:passenger | passenger id = 1].
	result := query executeIn: session.
	self assert: result id = 1.
	self assert: result name = 'Some Passenger'.
	self assert: result frequentFlyerPoints = 10000] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadRelationshipField [
	| query results |
	
	[session beginTransaction.
	query := Query read: GlorpItinerary where: [:each | ((each getTable: 'ITINERARY') getField: 'RES_ID') = nil].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 0.
]

{ #category : #tests }
GlorpReadingTest >> testReadReservationWithJoinToPassenger [
	| reservations |
	
	[session beginTransaction.
	self writeReservationData.
	session beginUnitOfWork.
	reservations := session read: GlorpReservation
				where: [:each | each passenger id = 3].
	self assert: reservations size = 1.
	self assert: reservations first passengers size = 1.] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadReservationWithPassenger [
	
	| reservation passenger reservations |
	[session beginTransaction.
	self writeReservationData.
	session beginUnitOfWork.
	"This doesn't validate so well. We want to make sure that the passenger table read uses a join and gets back only the one row, but it's hard to test that. Putting in an error check in the query for readOne... that returns multiple would work, but is kind of intrusive"
	reservations := session read: GlorpReservation where: [:each | each id = 2].
	self assert: reservations size = 1.
	reservation := reservations first.
	passenger := reservation passenger.
	passenger id.
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadTransactionsWithIndependentSubselect [
	| query result query2 matchingResult |
	
	[session beginTransaction.
	self write2CustomerRowsWith3Transactions.
	query := Query read: GlorpBankTransaction where: [:each |
		each exists: (Query read: GlorpCustomer where: [:eachCustomer |
			(eachCustomer id = each owner id) & (eachCustomer name = 'anotherCustomer')])].
	query orderBy: [:each | each owner name].
	"Another way of saying the same thing"
	query2 := Query read: GlorpBankTransaction where: [:each | each owner name = 'anotherCustomer'].
	result := session execute: query.
	matchingResult := session execute: query2.
	self assert: result size = matchingResult size.
	result with: matchingResult do: [:one :other |
		self assert: one = other]] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadTransactionsWithIndependentSubselectAndNot [
	| query result query2 matchingResult |
	
	[session beginTransaction.
	self write2CustomerRowsWith3Transactions.
	query := Query read: GlorpBankTransaction where: [:each |
		each notExists: (Query read: GlorpCustomer where: [:eachCustomer |
			(eachCustomer id = each owner id) & (eachCustomer name = 'anotherCustomer')])].
	query orderBy: [:each | each owner name].
	"Another way of saying the same thing"
	query2 := Query read: GlorpBankTransaction where: [:each | each owner name ~= 'anotherCustomer'].
	query2 orderBy: [:each | each owner name].
	result := session execute: query.
	matchingResult := session execute: query2.
	self assert: result size = matchingResult size.
	result with: matchingResult do: [:one :other |
		self assert: one = other]] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadTransactionsWithMaxSubselect [
	| query result |
	
	[session beginTransaction.
	self write2CustomerRowsWith3Transactions.
	query := Query read: GlorpBankTransaction where: [:each |
		each amount amount = ((Query read: GlorpBankTransaction
			where: [:eachTrans | eachTrans owner = each owner]) 
				retrieve: [:eachTrans | eachTrans amount amount max])].
	query orderBy: [:each | each owner name].
	result := session execute: query.
	self assert: result size = 2.
	self assert: result first amount amount = 10.
	self assert: result last amount amount = 11.
	self assert: result first owner id ~= result last owner id] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadTransactionsWithMaxSubselectAndRetrieveMax [
	| query result |
	
	[session beginTransaction.
	self write2CustomerRowsWith3Transactions.
	query := Query read: GlorpBankTransaction where: [:each |
		each amount amount = ((Query read: GlorpBankTransaction
			where: [:eachTrans | eachTrans owner = each owner]) 
				retrieveMax: [:eachTrans | eachTrans amount amount])].
	query orderBy: [:each | each owner name].
	result := session execute: query.
	self assert: result size = 2.
	self assert: result first amount amount = 10.
	self assert: result last amount amount = 11.
	self assert: result first owner id ~= result last owner id] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadWithCacheHits [
	| query addressRow result1 result2 |
	
	[session beginTransaction.
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
	query := Query readOneOf: GlorpAddress
				where: [:address | address id = 123].
	result1 := query executeIn: session.
	result2 := query executeIn: session.
	self assert: result1 == result2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadWithFalseWhereClause [
	| query id1 id2 result accountIds |
	
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	id1 := accountIds at: 1.
	id2 := accountIds at: 2.
	query := Query read: GlorpBankAccount
				where: false.
	result := session execute: query.
	self assert: result size = 0] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadWithLimit [
	| results |
	session platform supportsLimit ifFalse: [^self].
	results := Set new.
	[session beginTransaction.
	session
		inUnitOfWorkDo:
			[(1 to: 5) do: [:i | session register: ((GlorpAddress new)
													id: i;
													yourself)]].
	results
		add: (session execute: (SimpleQuery read: GlorpAddress limit: 3)) size;
		add: (session execute: (SimpleQuery read: GlorpAddress where: true limit: 3)) size;
		add: (session execute: (SimpleQuery read: GlorpAddress limit: 3)) size;
		add: (session execute: (SimpleQuery read: GlorpAddress where: true limit: 3)) size;
		add: (session read: GlorpAddress limit: 3) size;
		add: (session read: GlorpAddress where: true limit: 3) size.
	self assert: (results allSatisfy: [:ea | ea = 3])] ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpReadingTest >> testReadWithLimitAndOffset [

	session platform supportsOffset ifFalse: [^self].
	[session beginTransaction.
	session
		inUnitOfWorkDo:
			[(1 to: 5) do: [:i | session register: ((GlorpAddress new)
													id: i;
													yourself)]].
	self assert: (session execute: ((SimpleQuery read: GlorpAddress limit: 2)
									offset: 2;
									yourself)) size = 2.
	self assert: (session execute: ((SimpleQuery read: GlorpAddress limit: 0)
									offset: 2;
									yourself)) size = 0.
	self assert: (session execute: ((SimpleQuery read: GlorpAddress)
									offset: 6;
									yourself)) size = 0] ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpReadingTest >> testReadWithNilWhereClause [
	| query id1 id2 result accountIds |
	
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	id1 := accountIds at: 1.
	id2 := accountIds at: 2.
	query := Query read: GlorpBankAccount
				where: nil.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadWithObjectEqualityToEmbeddedObject [
	| query result |
	 
	[session beginTransaction.
	self writeCustomer1RowsWith2Transactions.
	query := Query
	read: GlorpBankTransaction
	where: [:trans | trans amount = (GlorpMoney currency: #CDN amount: 7)].
	result := session execute: query.
	self assert: result size = 1.
	self assert: result first amount amount = 7.
	self assert: result first amount currency = #CDN] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadWithObjectEqualityToEmbeddedObjectNested [
	| query result |
	 
	[session beginTransaction.
	self writeCustomer1RowsWith2Transactions.
	query := Query
		 read: GlorpBankTransaction
	where: [:trans | trans serviceCharge amount = (GlorpMoney currency: #CHF amount: 2)].
	result := session execute: query.
	self assert: result size = 1.
	self assert: result first serviceCharge amount amount = 2.
	self assert: result first serviceCharge amount currency = #CHF] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testReadWithOffset [
	session platform supportsOffset ifFalse: [^self].
	[session beginTransaction.
	session
		inUnitOfWorkDo:
			[(1 to: 5) do: [:i | session register: ((GlorpAddress new)
													id: i;
													yourself)]].
	self assert: (session execute: ((SimpleQuery read: GlorpAddress)
									offset: 2;
									yourself)) size = 3] ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpReadingTest >> testReadWithTrueWhereClause [
	| query id1 id2 result accountIds |
	
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	id1 := accountIds at: 1.
	id2 := accountIds at: 2.
	query := Query read: GlorpBankAccount
				where: true.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testRefreshAddress [
	"Check that we refresh correctly when the refresh flag is set"
	| query rowToWrite address modifiedRow |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	modifiedRow := session system exampleModifiedAddressRow.
	modifiedRow owner: address. "Otherwise it thinks it's an insert"
	session writeRow: modifiedRow.
	query := Query readOneOf: GlorpAddress where: [:each | each id = 123].
	query shouldRefresh: true.
	query executeIn: session.
	self assert: address street = 'Something Else'.] 
			ensure: [session rollbackTransaction].
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testRegexMatches [
	"This will fail on SQLite unless an application-defined SQL function named 'regexp' is added at run-time.  It will likewise fail on DB2 and SQLServer unless both a database function and a glorp reference to its name (which need not be regexp) have been added;  these database do not offer regex support, just the ability to add functions."

	| customers |
	
	session platform isUDBCSQLite3Platform ifTrue: [ ^ self skip. ].
	
	[session beginTransaction.
	session beginUnitOfWork.
	self writeCustomer1Rows.
	session reset.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'aCustomer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'a*omer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'a?ustomer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'aCusto(m|e|r)*'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'Not a customer'].
	self assert: customers isEmpty.
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testRegisteringWithEmbeddedMapping [

	| bankTrans |
	session beginUnitOfWork.
	bankTrans := self helperForTestReadEmbeddedOneToOne.
	self assert: (session isRegistered: bankTrans).
	self assert: (session isRegistered: bankTrans serviceCharge).
	self assert: (session isRegistered: bankTrans serviceCharge amount).
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testRetrieveComputed [
	| query  results |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each  id].
	query retrieve: [:each | each  id * 2].
	query retrieve: [:each | 2].
	query retrieve: [:each | each  id * each  id].
	results := query executeIn: session.
	results do: [:eachRow  | 
		self assert: (eachRow first * eachRow first) = eachRow last.
		self assert: (eachRow at: 2) = (2* eachRow first).
		self assert: (eachRow at: 3) = 2]]
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpReadingTest >> testSequencePolicyForInsert [
	| testObject |

	GlorpInMemorySequenceDatabaseType reset.
	[session beginTransaction.
	session beginUnitOfWork.
	testObject := GlorpAirline new.
	session register: testObject.
	session commitUnitOfWork.
	self assert: testObject id = 1]
		ensure: [session rollbackTransaction]
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testSessionRefresh [
	"Check that we refresh correctly when the refresh flag is set"
	self checkRefreshDoing: [:anAddress | session refresh: anAddress].
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testSessionRefreshOnExpiry [
	"Check that we refresh correctly when an object has expired"
	| cachePolicy |
	cachePolicy := TimedExpiryCachePolicy new.
	cachePolicy timeout: 0.
	cachePolicy expiryAction: #refresh.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkRefreshDoing: [:anAddress |
		session readOneOf: GlorpAddress where: [:each | each id = 123]].
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testSessionRefreshOnExpiryWithCacheLookupOnly [
	"Check that we refresh correctly when an object has expired, doing only a cache lookup, not an explicit read"
	| cachePolicy |
	cachePolicy := TimedExpiryCachePolicy new.
	cachePolicy timeout: 0.
	cachePolicy expiryAction: #refresh.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkRefreshDoing: [:anAddress |
		session privateGetCache lookupClass: GlorpAddress key: 123 ifAbsent: [nil]].
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testSessionRefreshOnProxyExpiry [
	"Check that we refresh correctly when an object has expired"
	| cachePolicy |
	cachePolicy := TimedStrongCachePolicy new.
	cachePolicy timeout: 0.
	cachePolicy expiryAction: #refresh.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkRefreshDoing: [:anAddress |
		session readOneOf: GlorpAddress where: [:each | each id = 123]].
]

{ #category : #'tests-refreshing' }
GlorpReadingTest >> testSessionRefreshOnProxyExpiryWithCacheLookupOnly [
	"Check that we refresh correctly when an object has expired, doing only a cache lookup, not an explicit read"
	| cachePolicy |
	cachePolicy := TimedStrongCachePolicy new.
	cachePolicy timeout: 0.
	cachePolicy expiryAction: #refresh.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkRefreshDoing: [:anAddress |
		session privateGetCache lookupClass: GlorpAddress key: 123 ifAbsent: [nil]].
]

{ #category : #tests }
GlorpReadingTest >> testShortCircuitEmptyReturnWhenLimitMeansNoResults [
	self deny: (SimpleQuery read: GlorpAddress limit: 3) shortCircuitEmptyReturn.
	self assert: (SimpleQuery read: GlorpAddress limit: 0) shortCircuitEmptyReturn.
	self assert: (SimpleQuery read: GlorpAddress limit: -3) shortCircuitEmptyReturn
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testSimilarTo [
	"Postgres and Firebird (and Sybase) support the ANSI SQL 'SIMILAR TO' form of regex (in which the % and _ of SQL's LIKE predicate replace the corresponding * and ? of regex) but most databases do not."

	| customers |	
	[session beginTransaction.
	session beginUnitOfWork.
	self writeCustomer1Rows.
	session reset.
	customers := session read: GlorpCustomer where: [:each | each name similarTo: 'aCustomer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name similarTo: 'a%omer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name similarTo: 'a_ustomer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name similarTo: 'Not a customer'].
	self assert: customers isEmpty.
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-functions' }
GlorpReadingTest >> testSum [
	| query result |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountNumber branchNumber sum].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = 5] 
			ensure: [session rollbackTransaction]
]

{ #category : #support }
GlorpReadingTest >> write2CustomerRowsWith3Transactions [
	| table row aGlorpDemoDescriptorSystem |
	session system writeCustomerWithDualAccountOwners.
	aGlorpDemoDescriptorSystem := session system.
	table := aGlorpDemoDescriptorSystem tableNamed: 'BANK_TRANS'.
	row := DatabaseRow newForTable: table.
	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'CDN'.
	row atFieldNamed: 'AMT_AMT' put: 9.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'CHF'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.
	row atFieldNamed: 'OWNER_ID' put: 27.
	session writeRow: row.
	row := DatabaseRow newForTable: table.
	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'USD'.
	row atFieldNamed: 'AMT_AMT' put: 10.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'CHF'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.
	row atFieldNamed: 'OWNER_ID' put: 27.
	session writeRow: row.
	row := DatabaseRow newForTable: table.
	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'EUR'.
	row atFieldNamed: 'AMT_AMT' put: 11.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'EUR'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.
	row atFieldNamed: 'OWNER_ID' put: 28.
	session writeRow: row.
]

{ #category : #support }
GlorpReadingTest >> writeCustomer1Rows [
	^system writeCustomer1Rows.
]

{ #category : #support }
GlorpReadingTest >> writeCustomer1RowsWith2Transactions [
	| table row aGlorpDemoDescriptorSystem |
	self writeCustomer1RowsWithTransactions.
	aGlorpDemoDescriptorSystem := session system.
	table := aGlorpDemoDescriptorSystem tableNamed: 'BANK_TRANS'.
	row := DatabaseRow newForTable: table.
	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'USD'.
	row atFieldNamed: 'AMT_AMT' put: 9.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'CHF'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.
	row atFieldNamed: 'OWNER_ID' put: 27.
	session writeRow: row.
]

{ #category : #support }
GlorpReadingTest >> writeCustomer1RowsWithTransactions [
	| table row aGlorpDemoDescriptorSystem |
	self writeCustomer1Rows.
	aGlorpDemoDescriptorSystem := session system.
	table := aGlorpDemoDescriptorSystem tableNamed: 'BANK_TRANS'.
	row := DatabaseRow newForTable: table.
	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'CDN'.
	row atFieldNamed: 'AMT_AMT' put: 7.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'USD'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.
	row atFieldNamed: 'OWNER_ID' put: 27.
	session writeRow: row.
]

{ #category : #support }
GlorpReadingTest >> writeReservationData [
	session beginUnitOfWork.
	session register: GlorpItinerary example1.
	session register: GlorpItinerary example2.
	session commitUnitOfWork.
	session writeRow: session system examplePassengerRow.
	session initializeCache
]
