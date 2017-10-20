tests
testUpdating

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