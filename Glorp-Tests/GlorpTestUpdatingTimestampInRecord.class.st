Class {
	#name : #GlorpTestUpdatingTimestampInRecord,
	#superclass : #GlorpSessionBasedTest,
	#category : 'Glorp-Tests-Database'
}

{ #category : #tests }
GlorpTestUpdatingTimestampInRecord >> testUpdating [

	| record firstTime secondTime |
	session beginTransaction.
	[
	"First verify that when we insert, a timestamp is set"
	record := GlorpRecordWithUpdateTime new id: 12; name: 'thing'.
	session modify: record in: [ ].
	session reset.
	record := session readOneOf: GlorpRecordWithUpdateTime.
	self assert: record id = 12.
	firstTime := record updateTime asSeconds.
	self assert: (firstTime - DateAndTime now asSeconds) < 2.
	"Now wait long enough for the timestamp to definitely change, and verify that if modify the object it changes"
	(Delay forSeconds: 2) wait.
	session modify: record in: [record name: 'different'].
	secondTime := record updateTime asSeconds.
	self deny: secondTime = firstTime.
	"Now verify that if we don't modify the object, we don't write the timestamp, or put it into the object"
	(Delay forSeconds: 2) wait.
	session modify: record in: [].
	self assert: record updateTime asSeconds = secondTime.
	session reset.
	record := session readOneOf: GlorpRecordWithUpdateTime.
	self assert: record updateTime asSeconds = secondTime.]
		ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpTestUpdatingTimestampInRecord >> testUpdatingComment [
	"Test that we update the unmapped comment field. We just put the printString of time now into the field, so most of the same sort of logic applies as in testUpdating."

	| record time time2 rows |
	session beginTransaction.
	[
	"First verify that when we insert, a comment is set"
	record := GlorpRecordWithUpdateTime new id: 12; name: 'thing'.
	time := Time now.
	session modify: record in: [ ].
	time2 := Time now.
	session reset.
	rows := session accessor executeSQLString: 'SELECT UPDATE_COMMENT from RECORD_WITH_UPDATE'.
	"Just in case the seconds flipped in that interval between us noting the time and the value being generated, check against before and after. I really can't see there being more than a one second gap in there"
	self assert: ((
		(rows first first asTime asDuration - time asDuration) < 1 second) or: [rows first first = time2]).

	"Now wait long enough for the time to definitely change, and verify that if modify the object it changes"
	(Delay forSeconds: 2) wait.
	record := session readOneOf: GlorpRecordWithUpdateTime.
	time := Time now.
	session modify: record in: [record name: 'different'].
	time2 := Time now.
	rows := session accessor executeSQLString: 'SELECT UPDATE_COMMENT from RECORD_WITH_UPDATE'.
	"Just in case the seconds flipped in that interval between us noting the time and the value being generated, check against before and after. I really can't see there being more than a one second gap in there"
	self assert: (rows first first asTime asDuration - time asDuration) < 1 seconds.

	"Now verify that if we don't modify the object, we don't write the comment, or put it into the object"
	(Delay forSeconds: 2) wait.
	session modify: record in: [].
	rows := session accessor executeSQLString: 'SELECT UPDATE_COMMENT from RECORD_WITH_UPDATE'.
	"Now verify that we still have the previous time value"
	self assert:  (rows first first asTime asDuration - time asDuration) < 1 seconds.
]
		ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpTestUpdatingTimestampInRecord >> testUpdatingOtherThing [
	"Test that we update the mapped other thing field. We just put the printString of time now into the field, so most of the same sort of logic applies as in testUpdating."

	| record time time2 newThing |
	session beginTransaction.
	[
	"First verify that when we insert, a comment is set"
	record := GlorpRecordWithUpdateTime new id: 12; name: 'thing'.
	time := Time now.
	session modify: record in: [ ].
	time2 := Time now.
	session reset.
	newThing := session readOneOf: GlorpRecordWithUpdateTime.
	"Just in case the seconds flipped in that interval between us noting the time and the value being generated, check against before and after. I really can't see there being more than a one second gap in there"
	self assert: (newThing updateSomeOtherThing asTime asDuration - time asDuration) < 1 second.

	"Now wait long enough for the time to definitely change, and verify that if modify the object it changes"
	(Delay forSeconds: 2) wait.
	session reset.
	record := session readOneOf: GlorpRecordWithUpdateTime.
	time := Time now.
	session modify: record in: [record name: 'different'].
	time2 := Time now.
	session reset.
	newThing := session readOneOf: GlorpRecordWithUpdateTime.
	self assert: (newThing updateSomeOtherThing asTime asDuration - time asDuration) < 1 second.

	record := session readOneOf: GlorpRecordWithUpdateTime.
	"Now verify that if we don't modify the object, we don't write the comment, or put it into the object"
	(Delay forSeconds: 2) wait.
	session modify: record in: [].
	session reset.
	newThing := session readOneOf: GlorpRecordWithUpdateTime.
	self assert: (newThing updateSomeOtherThing asTime asDuration - time asDuration) < 1 second.

]
		ensure: [session rollbackTransaction].
]
