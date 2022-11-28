Class {
	#name : #GlorpTimestampTest,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #tests }
GlorpTimestampTest >> compareTime: read to: original [
	| zeroDuration max min |

	"MS SQL Server fails randomly because it has a resolution of 3 ms only."
	session platform class = SQLServerPlatform ifTrue: [
		max := original addMilliseconds: 3.
		min := original addMilliseconds: -3.
		^read between: min and: max].
	"Otherwise"
	^session platform supportsMillisecondsInTimes 
		ifTrue: [read = original]
		ifFalse: [read = original or: [read = (original + (-1 * original asDuration asMilliSeconds )) or: [read asSeconds = original asSeconds]]].
]

{ #category : #types }
GlorpTimestampTest >> defaultDatabaseType [
	^self platform timestamp
]

{ #category : #tests }
GlorpTimestampTest >> testTimeStamp [
	"This has to be UTC because postgres has time zones and will try and compensate"

	| time |
	time := Dialect timestampNow.
	self helpTestValue: nil.
	self
		helpTestValue: time
		compareWith:
			[:read :original | 
			"MS SQL Server fails randomly because it has a resolution of 3 ms only."
			"GNU Smalltalk seems to be quite lone in following the ANSI standard..."
			self compareTime: read to: original].
]

{ #category : #tests }
GlorpTimestampTest >> testTimeStampBetweenAnd [
	| record time newRecord |
	session system: (GlorpDemoDescriptorSystem forPlatform: session platform).
	self
		inTransactionDo:
			[record := (GlorpRecordWithUpdateTime new)
				id: 12;
				name: 'thing'.
			session modify: record in: [].
			session reset.
			record := session readOneOf: GlorpRecordWithUpdateTime.
			time := record updateTime.
			session reset.
			newRecord := session
				readOneOf: GlorpRecordWithUpdateTime
				where:
					[:each | 
					each updateTime
						between: (time - 1 second)
						and: (time + 1 second)].
			self assert: newRecord id = record id.].
]

{ #category : #tests }
GlorpTimestampTest >> testTimeStampCast [
	"SQLite does not have time-related types:  they are all mapped to strings.  I have not debugged why this test fails yet but assume it is completely unrealistic to expect a string to be cast to a timestamp."

	| timestamp model |
	
	Dialect isPharo ifTrue: [ ^ self skip: 'Pharo does not implement #cast:.' ].
	
	timestamp := Dialect timestampNow.
	"OraclePlatform>>timestamp returns the 'DATE' type;  casting to Oracle DATE loses all data below seconds.  We therefore truncate the timestamp to seconds in what is (or can be made in Glorp*Port) a dialect-neutral way."
	timestamp := timestamp class fromSeconds: timestamp asSeconds.
	session transact: [session register: (GlorpTypeTestsModelClass new test: timestamp)].
	model := session readOneOf: GlorpTypeTestsModelClass where: [:each | (each test cast: session platform timestamp) = timestamp].
	self deny: model isNil
		description: 'This test will fail on SQLite which has no DB Timestamp type;  see test comment'.
	self assert: (self compareTime: model test to: timestamp).
	model := session readOneOf: GlorpTypeTestsModelClass where: [:each | (each test cast: session platform date) = timestamp].
	self deny: model isNil.
	self assert: (self compareTime: model test to: timestamp).

	model := session readOneOf: GlorpTypeTestsModelClass where: [:each | each test asTimestamp = timestamp].
	self deny: model isNil.
	self assert: (self compareTime: model test to: timestamp).
]

{ #category : #tests }
GlorpTimestampTest >> testTimeStampCompare [
	| record time newRecord |
	session system: (GlorpDemoDescriptorSystem forPlatform: session platform).
	self
		inTransactionDo:
			[record := (GlorpRecordWithUpdateTime new)
				id: 12;
				name: 'thing'.
			session modify: record in: [].
			session reset.
			record := session readOneOf: GlorpRecordWithUpdateTime.
			time := record updateTime.
			session reset.
			newRecord := session
				readOneOf: GlorpRecordWithUpdateTime
				where:
					[:each | 
						(each updateTime > (time - 1 second))
						& (each updateTime < (time + 1 second))].
			self assert: newRecord id = record id].
]
