Class {
	#name : #GlorpLoggingTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session',
		'loggedStatements'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

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

	super tearDown.
	session logging: false. 
	session rollbackTransaction.
	session reset.
	session := nil.
]

{ #category : #running }
GlorpLoggingTest >> testInsert [

	session loginIfError: [ self fail ].
	session beginTransaction.
	session writeRow: session system exampleAddressRowForOrdering1.
	self assert: loggedStatements size equals: 5.
	self assert: (loggedStatements at: 1) equals: 'Login'.
	self assert: (loggedStatements at: 2) equals: 'Login finished'.
	self assert: (loggedStatements at: 3) equals: 'Begin Transaction'.
	self
		assert: (loggedStatements at: 4)
		equals:
		'INSERT INTO GR_ADDRESS (ID,STREET,HOUSE_NUM)  VALUES (1,''Alpha'',''300'')'
]

{ #category : #running }
GlorpLoggingTest >> testLogin [

	session loginIfError: [ self fail ].

	self assert: loggedStatements size equals: 2.
	self assert: (loggedStatements at: 1) equals: 'Login'.
	self assert: (loggedStatements at: 2) equals: 'Login finished'.
]

{ #category : #running }
GlorpLoggingTest >> testSelectAll [

	session loginIfError: [ self fail ].
	(session read: GlorpBankTransaction).
	self assert: loggedStatements size equals: 3.
	self assert: (loggedStatements at: 1) equals: 'Login'.
	self assert: (loggedStatements at: 2) equals: 'Login finished'.
	self
		assert: (loggedStatements at: 3)
		equals:
		'SELECT t1.ID, t1.OWNER_ID, t1.AMT_CURR, t1.AMT_AMT, t1.SRVC_DESC, t1.SRVC_AMT_CURR, t1.SRVC_AMT_AMT
 FROM BANK_TRANS t1'
]

{ #category : #running }
GlorpLoggingTest >> testSelectWithLike [

	| query |
	session loginIfError: [ self fail ].

	query := Query read: GlorpAddress where: [ :each | each street like: 'Be%' ].
	session execute: query.

	self assert: loggedStatements size equals: 3.
	self assert: (loggedStatements at: 1) equals: 'Login'.
	self assert: (loggedStatements at: 2) equals: 'Login finished'.
	self
		assert: (loggedStatements at: 3)
		equals:
			'SELECT t1.ID, t1.STREET, t1.HOUSE_NUM
 FROM GR_ADDRESS t1
 WHERE (t1.STREET LIKE ''Be%'')'
]
