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

{ #category : #asserting }
GlorpLoggingTest >> assertExpectedInsertStatements [

	self subclassResponsibility
]

{ #category : #asserting }
GlorpLoggingTest >> assertExpectedLoginStatements [

	self subclassResponsibility
]

{ #category : #asserting }
GlorpLoggingTest >> assertExpectedSelectAllStatements [

	self subclassResponsibility
]

{ #category : #asserting }
GlorpLoggingTest >> assertExpectedSelectWithLikeStatements [

	self subclassResponsibility
]

{ #category : #accessing }
GlorpLoggingTest >> coveredPlatformType [

	self subclassResponsibility
]

{ #category : #'logger - api' }
GlorpLoggingTest >> cr [
	"Do nothing"
]

{ #category : #'logger - api' }
GlorpLoggingTest >> flush [
	"Do nothing"
]

{ #category : #'logger - api' }
GlorpLoggingTest >> nextPutAll: aString [

	loggedStatements add: aString
]

{ #category : #running }
GlorpLoggingTest >> runCase [

	(GlorpDatabaseLoginResource defaultLogin database isKindOf: self coveredPlatformType)
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
	session
		rollbackTransaction;
		reset.
	session := nil.
	super tearDown
]

{ #category : #tests }
GlorpLoggingTest >> testInsert [

	session
		loginIfError: [ self fail ];
		beginTransaction;
		writeRow: session system exampleAddressRowForOrdering1.

	self assertExpectedInsertStatements
]

{ #category : #tests }
GlorpLoggingTest >> testLogin [

	session loginIfError: [ self fail ].

	self assertExpectedLoginStatements
]

{ #category : #tests }
GlorpLoggingTest >> testSelectAll [

	session
		loginIfError: [ self fail ];
		read: GlorpBankTransaction.

	self assertExpectedSelectAllStatements
]

{ #category : #tests }
GlorpLoggingTest >> testSelectWithLike [

	| query |
	session loginIfError: [ self fail ].
	query := Query
		         read: GlorpAddress
		         where: [ :each | each street like: 'Be%' ].
	session execute: query.

	self assertExpectedSelectWithLikeStatements
]
