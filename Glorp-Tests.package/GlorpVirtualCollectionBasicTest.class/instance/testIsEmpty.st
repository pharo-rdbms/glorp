tests
testIsEmpty
	| vc2 |
	self deny: vc isEmpty.
	vc2 := vc select: [:each | each id = 98].
	self assert: vc2 isEmpty.