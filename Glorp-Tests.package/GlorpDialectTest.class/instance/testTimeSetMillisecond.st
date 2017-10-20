tests
testTimeSetMillisecond
	| time oldMs oldSec oldMin newMs |
	Dialect supportsMillisecondsInTimes ifFalse: [^self].
	time := Time now.
	oldMs := time milliseconds.
	oldSec := time seconds truncated.
	oldMin := time minutes.
	newMs := oldMs > 989 ifTrue: [3] ifFalse: [oldMs + 10].
	time millisecond: newMs.
	self assert: time milliseconds = newMs.
	self assert: time seconds truncated = oldSec.
	self assert: time minutes = oldMin.