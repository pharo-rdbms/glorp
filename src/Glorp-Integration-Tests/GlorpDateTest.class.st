Class {
	#name : #GlorpDateTest,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpDateTest >> defaultDatabaseType [
	^self platform date
]

{ #category : #tests }
GlorpDateTest >> testDate [

	| date |
	date := Date today.
	stType := Date.

	self helpTestValue: date.
	self helpTestValue: nil.
]

{ #category : #tests }
GlorpDateTest >> testDateCast [
	"SQLite does not have time-related types:  they are all mapped to strings.  I have not debugged why this test fails yet but assume it is completely unrealistic to expect a string to be cast to a timestamp."

	| date model |
	
	Dialect isPharo ifTrue: [ ^ self skip: 'Pharo does not implement #cast:.' ].
	
	date := Date today.
	session transact: [session register: (GlorpTypeTestsModelClass new test: date)].
	model := session readOneOf: GlorpTypeTestsModelClass where: [:each | (each test cast: session platform date) = date].
	self deny: model isNil
		description: 'This test will fail on SQLite which has no DB Date type;  see test comment'.
	self assert: model test = date.

	model := 	model := session platform isDB2Platform
		ifTrue:
			[session readOneOf: GlorpTypeTestsModelClass where: [:each | (each test timestamp: (each test time0)) = date]]
		ifFalse:
			[session readOneOf: GlorpTypeTestsModelClass where: [:each | (each test cast: session platform timestamp) = date]].
	self deny: model isNil.
	self assert: model test = date.

	model := session readOneOf: GlorpTypeTestsModelClass where: [:each | each test asDate = date].
	self deny: model isNil.
	self assert: model test = date.
]
