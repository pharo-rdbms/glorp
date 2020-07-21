Class {
	#name : #GlorpDatabaseBasedTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'system'
	],
	#category : #'Glorp-Unit-Tests-Database'
}

{ #category : #testing }
GlorpDatabaseBasedTest class >> isAbstract [

	^ self = GlorpDatabaseBasedTest
]

{ #category : #support }
GlorpDatabaseBasedTest >> assert: aBrackettedString equalsIgnoringOuterBrackets: anotherString [
	self assert: aBrackettedString =
		(anotherString first = $(
			ifTrue: [anotherString]
			ifFalse: ['(', anotherString, ')'])
]

{ #category : #support }
GlorpDatabaseBasedTest >> setUp [
	system := GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database.
	system session: GlorpMockSession new.
	system session system: system.
]
