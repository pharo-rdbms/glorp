Class {
	#name : #GlorpInsertUpdateTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpInsertUpdateTest class >> resources [

	^Array with: GlorpSessionResource.
]

{ #category : #support }
GlorpInsertUpdateTest >> rowFor: anObject [

	| rowMap rows |
	rowMap := RowMap new.
	session createRowsFor: anObject in: rowMap.
	rows := rowMap rowsForKey: anObject.
	self assert: rows size = 1.
	^rows first.
]

{ #category : #running }
GlorpInsertUpdateTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession
]

{ #category : #tests }
GlorpInsertUpdateTest >> testFunctionalInsertUpdateForInsert [

	| testObject |
	[session beginTransaction.
	session beginUnitOfWork.
	testObject := GlorpCustomer example1.
	testObject id: 876.
	session register: testObject.
	session commitUnitOfWork.
	self assert: (testObject seenPreWrite = true).
	self assert: (testObject seenPostWrite = true).

	session beginUnitOfWork.
	session register: testObject.
	testObject name: 'Change of name'.
	session commitUnitOfWork]
		ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpInsertUpdateTest >> testRowOwnership [

	| aCustomer rowMap |
	aCustomer := GlorpCustomer new.
	rowMap := RowMap new.
	(session descriptorFor: GlorpCustomer) createRowsFor: aCustomer in: rowMap.
	rowMap rowsDo: [:each | 
		self assert: each owner = aCustomer].
]

{ #category : #tests }
GlorpInsertUpdateTest >> testShouldInsertForInsert [

	| testObject row |
	testObject := GlorpCustomer example1.
	testObject id: 876.
	row :=self rowFor: testObject.
	self assert: (session shouldInsert: row).
]

{ #category : #tests }
GlorpInsertUpdateTest >> testShouldInsertForUpdate [

	| testObject row |
	session beginUnitOfWork.
	testObject := GlorpCustomer example1.
	testObject id: 876.
	session cacheAt: 876 put: testObject.
	row :=self rowFor: testObject.
	self deny: (session shouldInsert: row).
]
