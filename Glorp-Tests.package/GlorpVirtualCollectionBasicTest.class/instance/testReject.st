tests
testReject
	| vc2 |
	vc2 := vc reject: [:each | each id > 87 ].
	self deny: vc isInstantiated.
	self deny: vc2 isInstantiated.
	self assert: vc2 size = 2.
	self deny: vc isInstantiated.
	self assert: vc size = 3.
	self assert: (self realObjectsFrom: vc2) size = 2.