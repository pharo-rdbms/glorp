tests
testMessageIntercept

	| foo |
	foo := collector foo.
	self assert: foo privateGlorpSelector == #foo.
	self assert: foo privateGlorpReceiver == collector.