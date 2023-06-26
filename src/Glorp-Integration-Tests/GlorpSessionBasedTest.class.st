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

{ #category : #running }
GlorpSessionBasedTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession.
	system session: session.
	session system: system
]

{ #category : #running }
GlorpSessionBasedTest >> tearDown [

	session ifNotNil: [
		session
			reset;
			resetPermissions ].
	session := nil.
	super tearDown
]
