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

{ #category : #asserting }
GlorpDatabaseBasedTest >> assert: aBrackettedString equalsIgnoringOuterBrackets: anotherString [

	self assert: aBrackettedString equals: (anotherString first = $(
			 ifTrue: [ anotherString ]
			 ifFalse: [ '(' , anotherString , ')' ])
]

{ #category : #running }
GlorpDatabaseBasedTest >> setUp [

	super setUp.
	system := GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database.
	system session: GlorpMockSession new.
	system session system: system
]
