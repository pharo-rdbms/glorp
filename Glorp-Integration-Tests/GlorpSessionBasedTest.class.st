Class {
	#name : #GlorpSessionBasedTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpSessionBasedTest class >> resources [
	^Array with: GlorpDatabaseLoginResource with: GlorpSessionResource with: GlorpDemoTablePopulatorResource.
]

{ #category : #support }
GlorpSessionBasedTest >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
	system session: session.
	session system: system.
]

{ #category : #support }
GlorpSessionBasedTest >> tearDown [
	session isNil ifFalse: [session reset. session resetPermissions].
	session := nil.
	super tearDown.
]
