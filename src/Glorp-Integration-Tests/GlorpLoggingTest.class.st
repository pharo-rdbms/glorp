Class {
	#name : #GlorpLoggingTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session',
		'loggedStatements'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #testing }
GlorpLoggingTest class >> isAbstract [

	^ self name = #GlorpLoggingTest
]

{ #category : #running }
GlorpLoggingTest >> assertExpectedInsertStatements [

	self subclassResponsibility 
]

{ #category : #running }
GlorpLoggingTest >> assertExpectedLoginStatements [

	self subclassResponsibility 
]

{ #category : #running }
GlorpLoggingTest >> assertExpectedSelectAllStatements [

	self subclassResponsibility
]

{ #category : #running }
GlorpLoggingTest >> assertExpectedSelectWithLikeStatements [

	self subclassResponsibility
]

{ #category : #running }
GlorpLoggingTest >> coveredPlatformType [

	self subclassResponsibility 
]

{ #category : #'logger - api' }
GlorpLoggingTest >> cr [
	
	" do nothing "
]

{ #category : #'logger - api' }
GlorpLoggingTest >> flush [
	
	" do nothing "
]

{ #category : #'logger - api' }
GlorpLoggingTest >> nextPutAll: aString [

	loggedStatements add: aString
]

{ #category : #running }
GlorpLoggingTest >> runCase [

	(GlorpDatabaseLoginResource defaultLogin database isKindOf:
		 self coveredPlatformType)
		ifTrue: [ super runCase ]
		ifFalse: [ self skip ]
]

{ #category : #running }
GlorpLoggingTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession.
	session system: (GlorpDemoDescriptorSystem forPlatform:
			 GlorpDatabaseLoginResource defaultLogin database).
	session accessor
		logging: true;
		logger: self.
	loggedStatements := OrderedCollection new
]

{ #category : #running }
GlorpLoggingTest >> tearDown [

	session accessor logging: false.
	session rollbackTransaction.
	session reset.
	session := nil.
	super tearDown
]

{ #category : #running }
GlorpLoggingTest >> testInsert [

	session loginIfError: [ self fail ].
	session beginTransaction.
	session writeRow: session system exampleAddressRowForOrdering1.

	self assertExpectedInsertStatements
]

{ #category : #running }
GlorpLoggingTest >> testLogin [

	session loginIfError: [ self fail ].
	
	self assertExpectedLoginStatements
]

{ #category : #running }
GlorpLoggingTest >> testSelectAll [

	session loginIfError: [ self fail ].
	session read: GlorpBankTransaction.
	
	self assertExpectedSelectAllStatements
]

{ #category : #running }
GlorpLoggingTest >> testSelectWithLike [

	| query |
	session loginIfError: [ self fail ].
	query := Query
		         read: GlorpAddress
		         where: [ :each | each street like: 'Be%' ].
	session execute: query.

	self assertExpectedSelectWithLikeStatements
]
