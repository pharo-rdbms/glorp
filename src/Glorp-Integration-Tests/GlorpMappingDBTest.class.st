Class {
	#name : #GlorpMappingDBTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'system',
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpMappingDBTest class >> isAbstract [
	^self sunitName = #GlorpMappingDBTest
]

{ #category : #'as yet unclassified' }
GlorpMappingDBTest class >> resources [
	^Array with: GlorpSessionResource.
]

{ #category : #support }
GlorpMappingDBTest >> inTransactionDo: aBlock [
	[session beginTransaction.
	aBlock value] ensure: [session rollbackTransaction].
]

{ #category : #Running }
GlorpMappingDBTest >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
	system := session system.
]

{ #category : #support }
GlorpMappingDBTest >> tearDown [
	super tearDown.
	session reset.
	session resetPermissions.
	session := nil.
	system := nil.
]
