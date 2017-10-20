tests
testDropMissingTable
	| absentFlag |
	absentFlag := false.
	[self accessor beginTransaction.
	self accessor 
		dropTableNamed: 'GLORP_TEST_DROP' 
		ifAbsent: [:ex  | absentFlag := true. ex sunitExitWith: nil]]
	ensure: [self accessor rollbackTransaction].
	self assert: absentFlag