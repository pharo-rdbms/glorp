Class {
	#name : #GlorpObjectMappedToFunctionTest,
	#superclass : #GlorpSessionBasedTest,
	#category : 'Glorp-Tests-Database'
}

{ #category : #support }
GlorpObjectMappedToFunctionTest >> setUp [
	| accountRow3 |
	super setUp.
	session beginTransaction.
	system writeCustomer1Rows.
	accountRow3 := system exampleAccountRow3.
	session writeRow: accountRow3.
]

{ #category : #support }
GlorpObjectMappedToFunctionTest >> tearDown [
	session rollbackTransaction.
	super tearDown.
]

{ #category : #tests }
GlorpObjectMappedToFunctionTest >> testBasicRead [
	| branches |
	branches := session read: GlorpBankBranch.
	self assert: branches size = 3.
	self assert: (branches collect: [:each | each branchNumber]) asSortedCollection = #(2 3 712) asSortedCollection.
]

{ #category : #tests }
GlorpObjectMappedToFunctionTest >> testCache [
	| branches branch2 branch3 |
	branches := session read: GlorpBankBranch.
	branch2 := session readOneOf: GlorpBankBranch where: [:each | each branchNumber = 2].
	branch3 := session readOneOf: GlorpBankBranch where: [:each | each branchNumber = 3].
	self deny: branch2 == branch3.
	self assert: (branches includes: branch2).
	self assert: (branches includes: branch3).
]

{ #category : #tests }
GlorpObjectMappedToFunctionTest >> testNoWriteValidation [
	| |
	(session system descriptorFor: GlorpBankBranch) mappings next readOnly: false.
	self should: [session system validate] raise: Dialect error.
]

{ #category : #tests }
GlorpObjectMappedToFunctionTest >> testReadQueryingAttributes [
	| branches |
	branches := session read: GlorpBankBranch where: [:each |
		each accounts anySatisfy: [:eachAccount |
			eachAccount accountNumber accountNumber in: #( '3' '4')]].
	self assert: branches size = 2.
	self assert: branches asSet size = 2.
]

{ #category : #support }
GlorpObjectMappedToFunctionTest >> testRelationships [
	| branch accounts |
	branch := session readOneOf: GlorpBankBranch where: [:each | each branchNumber = 2].
	accounts := branch accounts yourself.
	self assert: accounts size = 1.
	self assert: accounts first id = 9874.
]
