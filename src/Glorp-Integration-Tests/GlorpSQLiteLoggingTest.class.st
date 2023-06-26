Class {
	#name : #GlorpSQLiteLoggingTest,
	#superclass : #GlorpLoggingTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #asserting }
GlorpSQLiteLoggingTest >> assertExpectedInsertStatements [

	self assert: loggedStatements size equals: 4.
	self assert: (loggedStatements at: 1) equals: 'Login'.
	self assert: (loggedStatements at: 2) equals: 'Login finished'.
	self assert: (loggedStatements at: 3) equals: 'Begin Transaction'.
	self
		assert: (loggedStatements at: 4)
		equals:
		'INSERT INTO GR_ADDRESS (ID,STREET,HOUSE_NUM)  VALUES (?,?,?)  #(1 ''Alpha'' ''300'')'
]

{ #category : #asserting }
GlorpSQLiteLoggingTest >> assertExpectedLoginStatements [

	self assert: loggedStatements size equals: 2.
	self assert: (loggedStatements at: 1) equals: 'Login'.
	self assert: (loggedStatements at: 2) equals: 'Login finished'
]

{ #category : #asserting }
GlorpSQLiteLoggingTest >> assertExpectedSelectAllStatements [

	self assert: loggedStatements size equals: 3.
	self assert: (loggedStatements at: 1) equals: 'Login'.
	self assert: (loggedStatements at: 2) equals: 'Login finished'.
	self
		assert: (loggedStatements at: 3)
		equals:
			'SELECT t1.ID, t1.OWNER_ID, t1.AMT_CURR, t1.AMT_AMT, t1.SRVC_DESC, t1.SRVC_AMT_CURR, t1.SRVC_AMT_AMT
 FROM BANK_TRANS t1  an OrderedCollection()'
]

{ #category : #asserting }
GlorpSQLiteLoggingTest >> assertExpectedSelectWithLikeStatements [

	self assert: loggedStatements size equals: 3.
	self assert: (loggedStatements at: 1) equals: 'Login'.
	self assert: (loggedStatements at: 2) equals: 'Login finished'.
	self
		assert: (loggedStatements at: 3)
		equals: 'SELECT t1.ID, t1.STREET, t1.HOUSE_NUM
 FROM GR_ADDRESS t1
 WHERE (t1.STREET LIKE ?)  an OrderedCollection(''Be%'')'
]

{ #category : #accessing }
GlorpSQLiteLoggingTest >> coveredPlatformType [

	^ SQLite3Platform
]
