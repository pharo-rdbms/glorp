Class {
	#name : #GlorpJoinTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'expression',
		'compoundExpression'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #support }
GlorpJoinTest >> setUp [
	super setUp.
	expression := Join 
		from: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID')
		to: ((system tableNamed: 'CUSTOMER_ACCT_LINK') fieldNamed: 'ACCT_ID').

	compoundExpression := Join
		from: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID')
		to: ((system tableNamed: 'PERSON') fieldNamed: 'NAME').
	compoundExpression
		addSource: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'BANK_CODE')
		target: ((system tableNamed: 'PERSON') fieldNamed: 'ADDRESS_ID').
]

{ #category : #tests }
GlorpJoinTest >> testAsExpressionCompound [
	
	| e personTable accountTable |
	personTable := system tableNamed: 'PERSON'.
	accountTable := system tableNamed: 'BANK_ACCT'.

	e := compoundExpression asGeneralGlorpExpression.
	self assert: (e isKindOf: RelationExpression).
	self assert: e relation == #AND.
	self assert: (e leftChild isKindOf: RelationExpression).
	self assert: (e leftChild relation == #=).
	self assert: (e leftChild leftChild isKindOf: FieldExpression).
	self assert: e leftChild leftChild field == (personTable fieldNamed: 'NAME').
	self assert: (e leftChild rightChild isKindOf: ParameterExpression).
	self assert: e leftChild rightChild field == (accountTable fieldNamed: 'ID').


	self assert: (e rightChild isKindOf: RelationExpression).
	self assert: (e rightChild relation == #=).
	self assert: (e rightChild leftChild isKindOf: FieldExpression).
	self assert: e rightChild leftChild field == (personTable fieldNamed: 'ADDRESS_ID').
	self assert: (e rightChild rightChild isKindOf: ParameterExpression).
	self assert: e rightChild rightChild field = (accountTable fieldNamed: 'BANK_CODE').
]

{ #category : #tests }
GlorpJoinTest >> testAsExpressionSingle [
	
	| e field param |
	e := expression asGeneralGlorpExpression.
	self assert: (e isKindOf: RelationExpression).
	self assert: e relation == #=.
	field := e leftChild.
	self assert: (field isKindOf: FieldExpression).
	self assert: field field == ((system tableNamed: 'CUSTOMER_ACCT_LINK') fieldNamed: 'ACCT_ID').
	param := e rightChild.
	self assert: (param isKindOf: ParameterExpression).
	self assert: param field == ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID').
]

{ #category : #tests }
GlorpJoinTest >> testCompoundSQLPrinting [

	| stream params|
	stream := WriteStream on: (String new: 100).
	params := Dictionary new.
	params at: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID') put: 1.
	params at: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'BANK_CODE') put: 3.
	compoundExpression printSQLOn: stream withParameters: params.
	self assert: stream contents equals: 'PERSON.NAME = 1 AND PERSON.ADDRESS_ID = 3'
]

{ #category : #tests }
GlorpJoinTest >> testCreation [

	self assert: expression allSourceFields size equals: 1.
	self assert: expression allSourceFields first == ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID').
]

{ #category : #tests }
GlorpJoinTest >> testParameterCount [

	self assert: expression numberOfParameters equals: 1.
	self assert: compoundExpression numberOfParameters equals: 2
]

{ #category : #tests }
GlorpJoinTest >> testSQLPrinting [

	| stream params |
	stream := WriteStream on: (String new: 100).
	params := Dictionary new.
	params at: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID') put: 'abc'.
	expression printSQLOn: stream withParameters: params.
	self assert: stream contents equals: 'CUSTOMER_ACCT_LINK.ACCT_ID = ''abc'''
]
