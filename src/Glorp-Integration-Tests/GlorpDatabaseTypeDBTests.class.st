Class {
	#name : #GlorpDatabaseTypeDBTests,
	#superclass : #GlorpTestCase,
	#instVars : [
		'type',
		'stType',
		'connection',
		'session'
	],
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #'as yet unclassified' }
GlorpDatabaseTypeDBTests class >> resources [
	^Array with: GlorpSessionResource
]

{ #category : #accessing }
GlorpDatabaseTypeDBTests >> platform [
	^connection platform
]

{ #category : #running }
GlorpDatabaseTypeDBTests >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession.
	connection := session accessor
]

{ #category : #running }
GlorpDatabaseTypeDBTests >> tearDown [

	session reset.
	session := nil.
	super tearDown
]

{ #category : #'infrastructure tests' }
GlorpDatabaseTypeDBTests >> testReadTime [
	self platform readTime: '18:06:22.12' for: self platform time.
]

{ #category : #tests }
GlorpDatabaseTypeDBTests >> testSerial [
	"type := PGSerialType instance.
	self assert: false.

	self assert: (type typeString = 'SERIAL')"
]

{ #category : #tests }
GlorpDatabaseTypeDBTests >> testTypeParametersNotAliased [

	| type2 type3 |
	type := (self platform) varchar.
	self assert: type width isNil.
	self assert: (type2 := self platform varChar: 5) width = 5.
	self assert: type width isNil.
	type3 := self platform varChar: 10.
	self assert: type3 width = 10.
	self assert: type2 width = 5.
	self assert: type width isNil.
]

{ #category : #tests }
GlorpDatabaseTypeDBTests >> testVarBinary [
	"Needs doing"
	self needsWork: 'write the test'.
]
