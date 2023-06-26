Class {
	#name : #GlorpWritingTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #accessing }
GlorpWritingTest class >> defaultTimeLimit [

	^ 1 minute
]

{ #category : #running }
GlorpWritingTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession
]

{ #category : #running }
GlorpWritingTest >> tearDown [

	session reset.
	session := nil.
	super tearDown
]

{ #category : #tests }
GlorpWritingTest >> testLargeWrite [
	"This is really just a performance test. No assertions. It should take on the order of 10 seconds. If it starts taking 10 minutes, it indicates a potential problem...."
	| customer |
	session beginTransaction.
	[customer := GlorpCustomer new.
	customer name: 'foo'.
     customer id: 123.
	1 to: 5000 do: [:i | | transaction |
		transaction := GlorpBankTransaction new.
		transaction amount amount: i.
		customer addTransaction: transaction].
	session beginUnitOfWork.
	session register: customer.
	session commitUnitOfWork]
		ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpWritingTest >> testMultipleWritesAndReads [
	"Trying to narrow down on a problem with SQLiteEXDI"

	| names customers |
	session beginTransaction.
	[session beginUnitOfWork.
	names := OrderedCollection new.
	1 to: 10
		do: 
			[:i | 
			| nm |
			nm := 'John Doe ' , i printString.
			names add: nm.
			session register: ((GlorpCustomer new)
									id: i;
									name: nm;
									yourself)].
	session commitUnitOfWork.
	customers := session read: GlorpCustomer.
	self assert: (names asSortedCollection hasEqualElements: (customers collect: [:ea | ea name]) asSortedCollection).
	] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpWritingTest >> testRegistrationFromWrittenObject [
	| customer trans transactions |
	session beginTransaction.
	[customer := GlorpCustomer new.
	customer name: 'foo'.
     customer id: 123.
	session beginUnitOfWork.
	session register: customer.
	session commitUnitOfWork.
	trans := GlorpBankTransaction new.
	session beginUnitOfWork.
	session readOneOf: GlorpCustomer where: [:each | each id = customer id].
	customer addTransaction: trans.
	session commitUnitOfWork.
	transactions := session accessor executeSQLString: 'SELECT ID FROM BANK_TRANS WHERE OWNER_ID = ', customer id printString.
	self assert: transactions size = 1.
	self assert: (trans id = (transactions first atIndex: 1))]
		ensure: [session rollbackTransaction].
]
