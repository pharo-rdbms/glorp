Class {
	#name : #GlorpDeleteInUnitOfWorkTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'unitOfWork'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #running }
GlorpDeleteInUnitOfWorkTest >> setUp [

	| session |
	super setUp.
	session := GlorpMockSession new.
	session beginUnitOfWork.
	unitOfWork := session privateGetCurrentUnitOfWork.
	session system: (GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database)
]

{ #category : #'private - accessing' }
GlorpDeleteInUnitOfWorkTest >> system [

	^ unitOfWork session system
]

{ #category : #'private - accessing' }
GlorpDeleteInUnitOfWorkTest >> tableNamed: aString [

	^ self system tableNamed: aString
]

{ #category : #running }
GlorpDeleteInUnitOfWorkTest >> tearDown [

	unitOfWork := nil.
	super tearDown
]

{ #category : #tests }
GlorpDeleteInUnitOfWorkTest >> testCommit [

	unitOfWork delete: GlorpAddress example1.
	unitOfWork commit.
	self assert: unitOfWork numberOfRows equals: 1
]

{ #category : #tests }
GlorpDeleteInUnitOfWorkTest >> testDeleteRegistration [

	| obj |
	obj := Object new.
	unitOfWork delete: obj.
	self assert: (unitOfWork willDelete: obj).
	self deny: (unitOfWork willDelete: 3)
]

{ #category : #tests }
GlorpDeleteInUnitOfWorkTest >> testDeletesComeAfterUpdates [

	unitOfWork delete: GlorpAddress example1.
	unitOfWork register: GlorpCustomer example1.
	unitOfWork commit.
	self
		assert: unitOfWork session rows last table
		identicalTo: (self tableNamed: 'GR_ADDRESS')
]

{ #category : #tests }
GlorpDeleteInUnitOfWorkTest >> testDeletesInReverseOrder [
	"Not that good a test, because it could be luck with only two tables. Should test this at a lower level"

	| cust trans |
	cust := GlorpCustomer example2.
	trans := cust transactions first.
	"We need to give it a primary key or else the delete logic fails"
	trans id: 42.
	unitOfWork delete: cust.
	unitOfWork delete: trans.
	unitOfWork commit.
	self assert: unitOfWork session rows last owner identicalTo: cust.
	self
		assert: (unitOfWork session rows reverse at: 2) owner
		identicalTo: trans
]

{ #category : #tests }
GlorpDeleteInUnitOfWorkTest >> testGeneratingDeleteRows [

	unitOfWork delete: GlorpAddress example1.
	unitOfWork createRows.
	self assert: unitOfWork privateGetRowMap numberOfEntries equals: 1.
	unitOfWork
		rowsForTable: (self tableNamed: 'GR_ADDRESS')
		do: [ :each | self assert: each forDeletion ]
]
