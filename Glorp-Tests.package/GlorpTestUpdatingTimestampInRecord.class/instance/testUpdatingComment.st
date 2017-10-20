tests
testUpdatingComment
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