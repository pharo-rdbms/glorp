Class {
	#name : #GlorpSessionTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #support }
GlorpSessionTest >> addCustomerToCache [
	| customer |
	customer := GlorpCustomer example1.
	customer id: 3.
	session cacheAt: 3 put: customer.
	^customer
]

{ #category : #tests }
GlorpSessionTest >> helpTestUpdateWithExpiredExistingEntry: aCachePolicy [
	| customer customer2 row table unitOfWork |
	(session system descriptorFor: GlorpCustomer) 
		cachePolicy: aCachePolicy.
	customer := self addCustomerToCache.
	customer2 := GlorpCustomer new.
	customer2 id: customer id.
	customer2 name: 'Barney Rubble'.
	row := DatabaseRow newForTable: (table := system tableNamed: 'GR_CUSTOMER').
	row at: (table fieldNamed: 'ID') put: customer id.
	unitOfWork := UnitOfWork new.
	unitOfWork session: session.
	"Since there's already an object there, this shouldn't do anything"
	unitOfWork updateSessionCacheFor: customer2 withRow: row.
	self assert: (session expiredInstanceOf: GlorpCustomer key: 3) == customer.
]

{ #category : #tests }
GlorpSessionTest >> helpTestUpdateWithoutExpiredExistingEntry: aCachePolicy [
	| customer2 row table unitOfWork |
	(session system descriptorFor: GlorpCustomer) 
		cachePolicy: (TimedExpiryCachePolicy new timeout: 0).
	customer2 := GlorpCustomer new.
	customer2 id: 3.
	customer2 name: 'Barney Rubble'.
	row := DatabaseRow newForTable: (table := system tableNamed: 'GR_CUSTOMER').
	row at: (table fieldNamed: 'ID') put: 3.
	unitOfWork := UnitOfWork new.
	unitOfWork session: session.
	unitOfWork updateSessionCacheFor: customer2 withRow: row.
	self assert: (session expiredInstanceOf: GlorpCustomer key: 3) == customer2.
]

{ #category : #running }
GlorpSessionTest >> setUp [

	super setUp.
	session := GlorpSession new.
	session system: system
]

{ #category : #tests }
GlorpSessionTest >> testAddingDescriptors [

	self assert: session system == system.
	self assert: system session == session.
	(session descriptorFor: GlorpAddress) session == session.
]

{ #category : #tests }
GlorpSessionTest >> testDuplicateDetection [
	| customer customer2 |
	session beginUnitOfWork.
	customer := self addCustomerToCache.
	customer2 := customer copy.
	self should: [session register: customer2] raise: Dialect error.
	session rollbackUnitOfWork.
]

{ #category : #tests }
GlorpSessionTest >> testExecuteQuery [

	| q result |
	q := GlorpQueryStub new result: 3.
	result := session execute: q.
	self assert: result equals: 3
]

{ #category : #tests }
GlorpSessionTest >> testHasExpired1 [
	| customer |
	customer := self addCustomerToCache.
	self deny: (session hasExpired: customer)
]

{ #category : #tests }
GlorpSessionTest >> testHasExpired2 [
	| customer |
	(session system descriptorFor: GlorpCustomer) 
		cachePolicy: (TimedExpiryCachePolicy new timeout: 0).
	customer := self addCustomerToCache.
	self assert: (session hasExpired: customer)
]

{ #category : #tests }
GlorpSessionTest >> testHasExpired3 [
	| customer |
	(session system descriptorFor: GlorpCustomer) 
		cachePolicy: (TimedExpiryCachePolicy new timeout: 0).
	customer := self addCustomerToCache.
	self assert: (session hasExpired: customer)
]

{ #category : #tests }
GlorpSessionTest >> testHasObjectOfClassExpired1 [

	self addCustomerToCache.
	self deny: (session hasObjectExpiredOfClass: GlorpCustomer withKey: 3).
]

{ #category : #tests }
GlorpSessionTest >> testHasObjectOfClassExpired2 [

	(session system descriptorFor: GlorpCustomer) 
		cachePolicy: (TimedExpiryCachePolicy new timeout: 0).
	self addCustomerToCache.
	self assert: (session hasObjectExpiredOfClass: GlorpCustomer withKey: 3).
]

{ #category : #tests }
GlorpSessionTest >> testSQLDeleteStringFor [

	| row table string |
	table := session system tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'ID') put: 12.
	row at: (table fieldNamed: 'STREET') put: 'some street'.
	string := (DeleteCommand forRow: row useBinding: true session: session) sqlString.
	self assert: string equals: 'DELETE FROM GR_ADDRESS WHERE ID = ?'.
	string := (DeleteCommand forRow: row useBinding: false session: session) sqlString.
	self assert: string equals: 'DELETE FROM GR_ADDRESS WHERE ID = 12'
]

{ #category : #tests }
GlorpSessionTest >> testUpdateWithExpiredExistingEntry [
	self helpTestUpdateWithExpiredExistingEntry: (TimedExpiryCachePolicy new timeout: 0; expiryAction: #refresh).
]

{ #category : #tests }
GlorpSessionTest >> testUpdateWithExpiredExistingEntry2 [
	self helpTestUpdateWithExpiredExistingEntry: (TimedStrongCachePolicy new timeout: 0; expiryAction: #refresh).
]

{ #category : #tests }
GlorpSessionTest >> testUpdateWithoutExpiredExistingEntry [
	self helpTestUpdateWithoutExpiredExistingEntry: (TimedExpiryCachePolicy new timeout: 0).
]

{ #category : #tests }
GlorpSessionTest >> testUpdateWithoutExpiredExistingEntry2 [
	self helpTestUpdateWithoutExpiredExistingEntry: (TimedStrongCachePolicy new timeout: 0).
]
