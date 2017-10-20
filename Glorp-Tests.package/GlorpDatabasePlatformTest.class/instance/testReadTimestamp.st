tests
testReadTimestamp

	| ts |
	ts := DatabasePlatform new readTimestamp: '2003-03-03 15:29:28.337-05' for: nil.
	self assert: ts asSeconds + ts offset asSeconds = 3224158168.
	self assert: ([ts asMilliseconds + ts offset asMilliSeconds = 3224158168337 ]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #asMilliseconds ]).

	ts := DatabasePlatform new readTimestamp: '2003-03-13 15:29:28.337-05' for: nil.
	self assert: ts asSeconds + ts offset asSeconds = 3225022168.
	self assert: ([ts asMilliseconds + ts offset asMilliSeconds = 3225022168337]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #asMilliseconds ])