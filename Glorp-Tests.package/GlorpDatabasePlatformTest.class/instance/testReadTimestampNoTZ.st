tests
testReadTimestampNoTZ

	| ts |
	ts := DatabasePlatform new readTimestamp: '1975-08-13 21:29:28.337' for: nil.
	self assert: ts year = 1975.
	self assert: ts monthIndex = 8.
	self assert: ts dayOfMonth = 13.
	self assert: ts hours = 21.
	self assert: ts minutes = 29.
	self assert: ts seconds truncated = 28.
	self assert: ([ ts milliseconds =  337]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #milliseconds ])