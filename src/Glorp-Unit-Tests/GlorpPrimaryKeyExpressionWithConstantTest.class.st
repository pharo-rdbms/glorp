Class {
	#name : #GlorpPrimaryKeyExpressionWithConstantTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'expression',
		'compoundExpression'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #running }
GlorpPrimaryKeyExpressionWithConstantTest >> setUp [

	super setUp.
	expression := Join
		from: 7
		to: ((system tableNamed: 'CUSTOMER_ACCT_LINK') fieldNamed: 'ACCT_ID').

	compoundExpression := Join
		from: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID')
		to: ((system tableNamed: 'PERSON') fieldNamed: 'NAME').
	compoundExpression
		addSource: 'B'
		target: ((system tableNamed: 'PERSON') fieldNamed: 'ADDRESS_ID')
]

{ #category : #tests }
GlorpPrimaryKeyExpressionWithConstantTest >> testAsExpressionCompound [

	| e personTable |
	personTable := system tableNamed: 'PERSON'.

	e := compoundExpression asGeneralGlorpExpression.
	self assert: (e rightChild isKindOf: RelationExpression).
	self assert: e rightChild relation identicalTo: #=.
	self assert: (e rightChild leftChild isKindOf: FieldExpression).
	self
		assert: e rightChild leftChild field
		identicalTo: (personTable fieldNamed: 'ADDRESS_ID').
	self assert: (e rightChild rightChild isKindOf: ConstantExpression).
	self assert: e rightChild rightChild value equals: 'B'
]

{ #category : #tests }
GlorpPrimaryKeyExpressionWithConstantTest >> testAsExpressionSingle [

	| e field param |
	e := expression asGeneralGlorpExpression.
	self assert: (e isKindOf: RelationExpression).
	self assert: e relation identicalTo: #=.
	field := e leftChild.
	self assert: (field isKindOf: FieldExpression).
	self
		assert: field field
		identicalTo:
		((system tableNamed: 'CUSTOMER_ACCT_LINK') fieldNamed: 'ACCT_ID').
	param := e rightChild.
	self assert: (param isKindOf: ConstantExpression).
	self assert: param value equals: 7
]

{ #category : #tests }
GlorpPrimaryKeyExpressionWithConstantTest >> testCompoundSQLPrinting [

	| stream params|
	stream := WriteStream on: (String new: 100).
	params := Dictionary new.
	params at: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID') put: 1.
	compoundExpression printSQLOn: stream withParameters: params.
	self assert: stream contents equals: 'PERSON.NAME = 1 AND PERSON.ADDRESS_ID = ''B'''
]

{ #category : #tests }
GlorpPrimaryKeyExpressionWithConstantTest >> testParameterCount [

	self assert: expression numberOfParameters equals: 1.
	self assert: compoundExpression numberOfParameters equals: 2
]

{ #category : #tests }
GlorpPrimaryKeyExpressionWithConstantTest >> testSQLPrinting [

	| stream params |
	stream := WriteStream on: (String new: 100).
	params := Dictionary new.
	expression printSQLOn: stream withParameters: params.
	self assert: stream contents equals: 'CUSTOMER_ACCT_LINK.ACCT_ID = 7'
]
