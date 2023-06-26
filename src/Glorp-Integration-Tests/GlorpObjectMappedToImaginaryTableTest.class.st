Class {
	#name : #GlorpObjectMappedToImaginaryTableTest,
	#superclass : #GlorpSessionBasedTest,
	#instVars : [
		'example',
		'example2'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> db2testReadWithDateArithmeticInWhereClause [
	"DB2 appears fussy in how it allows date arithmetic.  Constant durations must be labelled (i.e. + 2 days, not just + 2, and the root of an expression with a duration must be a date or timestamp.  This could be read to mean that
	dueDate - 2 days - 2 hours
should be OK and
	dueDate - (2 days + 2 hours)
should not be (making it impossible to compute the printing of any multi-part duration expression) but in fact tests suggest that no arrangement of brackets will allow even
	dueDate - 2 days - 2 hours
and we must write only a single labelled duration expression
	dueDate - 2 days
We therefore provide functions for DB2's duration syntax and require users of DB2 to write their clauses to use them;  see DB2Platform>>initializeFunctions."

	| rentals paramKey query |
	Transcript cr; show: 'On DB2, testReadWithDateArithmeticInWhereClause only tests a limited range of date arithmetic.'.
	paramKey := DatabaseField named: #dayNum type: session platform integer.
	query := Query
		read: GlorpVideoRental
		where: [:each | each dueDate + (each parameter: paramKey) days > Date today].
	rentals := query
		executeWithParameters: (Dictionary new at: paramKey put: 1; yourself)
		in: session.
	self deny: rentals isEmpty.
	rentals := session
		read: GlorpVideoRental
		where: [:each | each dueDate + each id days > Date today].
	self deny: rentals isEmpty.
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> queryForComplexSubselectRead2: anInteger [
	"This exercises doubly-nested subselects, which caused a problem in a user application with joining to the wrong table. The gist of the query is stores where more than anInteger different customers have made rentals"

	| q1 q2 q3 |
	q1 := Query
		read: GlorpVideoStore
		where: [:store | 
			q2 := Query
				count: GlorpVideoCustomer
				where: [:customer | 
					q3 := Query
						read: GlorpVideoRental
						where: [:rental | rental customer = customer AND: (rental store = store)].
					q3 retrieve: [:trade | trade customerName].
					customer name in: q3].
			(store getConstant: anInteger) <= q2].
	^q1.
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> queryForComplexSubselectRead: anInteger [
	"This exercises doubly-nested subselects, which caused a problem in a user application with joining to the wrong table. The gist of the query is stores where more than anInteger different customers have made rentals"

	| q1 q2 q3 |
	q1 := Query
		read: GlorpVideoStore
		where: [:store | 
			q2 := Query
				count: GlorpVideoCustomer
				where: [:customer | 
					q3 := Query
						read: GlorpVideoRental
						where: [:rental | rental store = store].
					q3 retrieve: [:trade | trade customerName].
					customer name in: q3].
			(store getConstant: anInteger) <= q2].
	^q1.
]

{ #category : #running }
GlorpObjectMappedToImaginaryTableTest >> setUp [

	super setUp.
	system := GlorpVideoDescriptorSystem forPlatform: session platform.
	session system: system.
	session beginTransaction.
	example := system exampleStore1.
	example2 := system exampleStore2.
	session inUnitOfWorkDo: [session register: example. session register: example2.].
	session reset
]

{ #category : #running }
GlorpObjectMappedToImaginaryTableTest >> tearDown [

	session rollbackTransaction.
	super tearDown
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testComplexSubselectRead [
	"This exercises doubly-nested subselects, which caused a problem in a user application with joining to the wrong table"

	| |
	self assert: (session execute: (self queryForComplexSubselectRead: 3)) size = 1.
	self assert: (session execute: (self queryForComplexSubselectRead: 4)) size = 0.
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testComplexSubselectRead2 [
	"This exercises doubly-nested subselects, which caused a problem in a user application with joining to the wrong table"

	| |
	self assert: (session execute: (self queryForComplexSubselectRead2: 1)) size = 1.
	self assert: (session execute: (self queryForComplexSubselectRead2: 0)) size = 2.
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testReadBackAllCustomer [
	| customers |
	customers := session read: GlorpVideoCustomer.
	self assert: ((customers collect: [:each | each name]) asSortedCollection asArray) = #('Adrian' 'Bob' 'Carol' 'David' 'Eleanor' 'Francois' 'George' 'Hieronymous').
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testReadBackEntireExample [
	| store |
	store := session readOneOf: GlorpVideoStore where: [:each | each id = 1].
	example assertEqual: store.
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testReadCustomerWhere [
	| customers |
	customers := session read: GlorpVideoCustomer where: [:each | each name like: '%an%'].
	self assert: ((customers collect: [:each | each name]) asSortedCollection asArray) = #('Adrian'  'Eleanor' 'Francois').
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testReadCustomerWhereWithJoin [
	| customers |
	customers := session read: GlorpVideoCustomer where: [:each | each onlinePurchases anySatisfy: [:eachPurchase | eachPurchase price > 2]].
	self assert: ((customers collect: [:each | each name]) asSortedCollection asArray) = #('Adrian'  'George' ).
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testReadWithDateArithmeticInWhereClause [
	"Test date arithmetic using constant expressions and field expressions.  Trivially, we use the id field to get a positive integer - aim is just to verify the expression runs and returns the rows).
	The rental data is set up and torn down each time the test is run so (ignoring cross-midnight runs) their dates will always be today's date."

	| rentals |
	"Check date +/- integer expressions;  DB2 will not accept this unlabelled, so is tested separately."
	"session platform class == DB2Platform ifTrue:
		[^self db2testReadWithDateArithmeticInWhereClause]."
	session platform supportsArithmeticOperatorsOnDates ifFalse: [ self skip ].
	rentals := session read: GlorpVideoRental where:
		[:each | each dueDate + 1 > Date today].
	self deny: rentals isEmpty.
	rentals := session read: GlorpVideoRental where:
		[:each | each dueDate - (each id + each id) < Date today].
	self deny: rentals isEmpty.
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testReadWithDateFieldInWhereClause [

	| rentals |
	rentals := session read: GlorpVideoRental where: [ :each | 
		           each dueDate in: { 
				           Date today.
				           Date yesterday } ].
	self deny: rentals isEmpty
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testRefreshItemWithMappedPrimaryKeys [
	"Prior to vw8.0, Glorp would DNU if trying to refresh an object whose table's primaryKeys were values mapped to other objects, not directly to its instVars.  The primaryKeys of VIDEO_CREDIT_STATUS are mapped to objects in the instVars of its class GlorpVideoCreditStatus.  The refresh: now uses a base that knows its object's descriptor so no longer DNUs in this test."

	| creditStatus |
	creditStatus := session readOneOf: GlorpVideoCreditStatus.
	session refresh: creditStatus.
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testSelectByBoolean [

	| inStore notInStore inStoreImplied notInStoreImplied |
	inStore := session read: GlorpVideoPurchase where: [:each | each inStore = true].
	notInStore := session read: GlorpVideoPurchase where: [:each | each inStore = false].
	self assert: inStore size = 7.
	self assert: notInStore size = 3.
	inStoreImplied := session read: GlorpVideoPurchase where: [:each | each inStore].
	notInStoreImplied := session read: GlorpVideoPurchase where: [:each | each inStore not].
	self assert: inStoreImplied size = 7.
	self assert: notInStoreImplied size = 3.
]

{ #category : #tests }
GlorpObjectMappedToImaginaryTableTest >> testWrite [
	"Write and validate that it basically got written correctly, in terms of number and keys of db rows"

	| storeRows storeRow purchaseRows purchaseKeys rentalRows rentalKeys |
	storeRows := session accessor
		executeSQLString: 'SELECT * FROM VIDEO_STORE'.
	storeRows := storeRows asSortedCollection: [:a :b | a first <= b first].
	self assert: storeRows size = 2.
	storeRow := storeRows first.
	self assert: storeRow size = 2.
	self assert: storeRow first = 1.
	self assert: storeRow last = 'Als Video'.
	storeRow := storeRows last.
	self assert: storeRow first = 2.
	self assert: storeRow last = 'Bonzai Video'.
	purchaseRows := session accessor
		executeSQLString: 'SELECT * FROM VIDEO_PURCHASE'.
	self assert: purchaseRows size = 10.
	purchaseKeys := (purchaseRows collect: [:each | each atIndex: 1])
		asSortedCollection.
	self assert: purchaseKeys asArray = #(1 2 3 101 102 103 104 105 106 107).
	rentalRows := session accessor
		executeSQLString: 'SELECT * FROM VIDEO_RENTAL'.
	self assert: rentalRows size = 4.
	rentalKeys := (rentalRows collect: [:each | each atIndex: 1])
		asSortedCollection.
	self assert: rentalKeys asArray = #(1001 1002 1003 1004).
]
