tests
testReadTimestampNoMSNoTZ

	| ts |
	ts := DatabasePlatform new readTimestamp: '2003-03-03 15:29:28' for: nil.
	self assert: ts year = 2003.
	self assert: ts monthIndex = 3.
	self assert: ts dayOfMonth = 3.
	self assert: ts hours = 15.
	self assert: ts minutes = 29.
	self assert: ts seconds truncated = 28.
	self assert: ([ ts milliseconds = 0 ]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #milliseconds ])