tests
testRelease
	| person |
	stream next.
	stream release.
	self assert: stream atEnd.
	self assert: stream next isNil.