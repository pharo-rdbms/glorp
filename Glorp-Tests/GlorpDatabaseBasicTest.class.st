Class {
	#name : #GlorpDatabaseBasicTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'system'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpDatabaseBasicTest class >> resources [
	^Array with: GlorpDatabaseLoginResource with: GlorpDemoTablePopulatorResource.
]

{ #category : #accessing }
GlorpDatabaseBasicTest >> accessor [
	^self databaseLoginResource accessor
]

{ #category : #support }
GlorpDatabaseBasicTest >> databaseLoginResource [
	^GlorpDatabaseLoginResource current.
]

{ #category : #support }
GlorpDatabaseBasicTest >> setUp [

	super setUp.
	system := GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database.
]

{ #category : #tests }
GlorpDatabaseBasicTest >> testBeginTransactionWithCommit [
	self assert: self accessor isInTransaction not.
	self accessor beginTransaction.
	self assert: self accessor isInTransaction.
	self accessor commitTransaction.
	self assert: self accessor isInTransaction not
]

{ #category : #tests }
GlorpDatabaseBasicTest >> testBeginTransactionWithRollback [
	self assert: self accessor isInTransaction not.
	self accessor beginTransaction.
	self assert: self accessor isInTransaction.
	self accessor rollbackTransaction.
	self assert: self accessor isInTransaction not
]

{ #category : #tests }
GlorpDatabaseBasicTest >> testCreateTable [
	| selectResult presentFlag |
	presentFlag := true.
	[[self accessor beginTransaction.
	self accessor
		executeSQLStringNoResult: 'CREATE TABLE GLORP_TEST_CREATE (ID varchar(4))'] 
		ensure: [self accessor commitTransaction].
	selectResult := self accessor
		executeSQLString: 'SELECT * FROM GLORP_TEST_CREATE'.
	self assert: selectResult isEmpty]
		ensure:
			[[self accessor
				beginTransaction;
				dropTableNamed: 'GLORP_TEST_CREATE'
					ifAbsent: [:ex |presentFlag := false. ex sunitExitWith: nil]]
				ensure: [self accessor commitTransaction]].
	self assert: presentFlag
		description: 'Tried to drop the created table but it was already absent'.
]

{ #category : #tests }
GlorpDatabaseBasicTest >> testDropMissingTable [
	| absentFlag |
	absentFlag := false.
	[self accessor beginTransaction.
	self accessor 
		dropTableNamed: 'GLORP_TEST_DROP' 
		ifAbsent: [:ex  | absentFlag := true. ex sunitExitWith: nil]]
	ensure: [self accessor rollbackTransaction].
	self assert: absentFlag
]

{ #category : #tests }
GlorpDatabaseBasicTest >> testNameBinding [
	| selectResult |
	"This is more of a low-level db functionality test than a glorp test, but it's convenient to be able ot write it here"
	self accessor platform supportsBinding ifFalse: [^self skip: 'Current database platform does not support parameter binding.'].
	[self accessor beginTransaction.
	self accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (10,''abc'')'.
	self accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (20,''def'')'.
	self accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (30,''ghi'')'.
	selectResult := self accessor 
		executeSQLString: 'SELECT * FROM STUFF WHERE ID = ? OR ID = ?'
			binding: {10. 30}.

	self assert: selectResult size = 2]
		ensure: [self accessor rollbackTransaction].
]

{ #category : #tests }
GlorpDatabaseBasicTest >> testReadEmpty [
	| results |
	results := self accessor
				executeSQLString: 'SELECT * FROM PERSON'.
	self assert: results size = 0
]

{ #category : #tests }
GlorpDatabaseBasicTest >> testReadStatement [
	| results |
	results := self accessor
				executeSQLString: 'SELECT * FROM STUFF ORDER BY ID'.
	self assert: results size = 5.
	self assert: results first size = 2.
	self assert: results first last =  'abc'
]

{ #category : #tests }
GlorpDatabaseBasicTest >> testRollbackRemovesData [
	"Just to make sure I'm not losing my mind"
	| numAddresses newNumAddresses|
	numAddresses := (self accessor executeSQLString: 'SELECT * FROM GR_ADDRESS') size.
	self accessor beginTransaction.
	self accessor executeSQLStringNoResult: 'INSERT INTO GR_ADDRESS (ID,STREET,HOUSE_NUM)  VALUES (111,''Main Street'',''77777'')'.
	newNumAddresses := (self accessor executeSQLString: 'SELECT * FROM GR_ADDRESS') size.
	self assert: newNumAddresses = (numAddresses + 1).
	self accessor rollbackTransaction.
	self assert: numAddresses = (self accessor executeSQLString: 'SELECT * FROM GR_ADDRESS') size.
]
