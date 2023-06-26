Class {
	#name : #GlorpDemoTablePopulatorResource,
	#superclass : #TestResource,
	#instVars : [
		'login'
	],
	#classVars : [
		'NeedsSetup'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpDemoTablePopulatorResource class >> invalidateSetup [
	"GlorpDemoTablePopulatorResource invalidateSetup"

	NeedsSetup := true.
	self reset.
]

{ #category : #'as yet unclassified' }
GlorpDemoTablePopulatorResource class >> needsSetup [
	NeedsSetup isNil ifTrue: [NeedsSetup := true].
	^NeedsSetup
]

{ #category : #'as yet unclassified' }
GlorpDemoTablePopulatorResource class >> needsSetup: aBoolean [

	NeedsSetup := aBoolean.
]

{ #category : #'as yet unclassified' }
GlorpDemoTablePopulatorResource class >> resources [

	^Array with: GlorpDatabaseLoginResource.
]

{ #category : #'private - running' }
GlorpDemoTablePopulatorResource >> populateStuffTable [
 
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (12,''abc'')'.
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (13, ''hey nonny nonny'')'.
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (42, ''yabba dabba doo'')'.
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (9625, ''the band played on'')'.
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (113141, ''Smalltalk'')'.
]

{ #category : #running }
GlorpDemoTablePopulatorResource >> setUp [

	super setUp.
	login := GlorpDatabaseLoginResource current.
	self class needsSetup ifFalse: [ ^ self ].
	login accessor doDDLOperation: [
		GlorpTestDescriptorSystem allSubclasses do: [ :eachSystemClass |
			self setUpSystem:
				(eachSystemClass forPlatform: login platform) setUpDefaults ].
		self populateStuffTable ]
]

{ #category : #'private - running' }
GlorpDemoTablePopulatorResource >> setUpSystem: system [

	| errorBlock |
	login accessor dropTables: ((TableSorter for: system allTables) sort reverse).
	errorBlock := [:ex | Transcript show: ex description; cr. ex pass].
	system platform areSequencesExplicitlyCreated ifTrue: [
		login accessor dropSequences: system allSequences.
		system allSequences do: [:each |
			login accessor createSequence: each ifError: errorBlock]].
	system allTables do: [:each |
			login accessor createTable: each
				ifError: errorBlock].
	system allTables do: [:each |
			login accessor createTableIndexes: each ifError: errorBlock].
	"SQLite3 doesn't support adding/dropping constraints."
	system platform supportsConstraints ifTrue: [
		system allTables do: [:each |
				login accessor createTableFKConstraints: each ifError: errorBlock]].

	self class needsSetup: false
]
