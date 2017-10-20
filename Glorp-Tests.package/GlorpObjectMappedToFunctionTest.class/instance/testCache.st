tests
testCache
	| branches branch2 branch3 |
	branches := session read: GlorpBankBranch.
	branch2 := session readOneOf: GlorpBankBranch where: [:each | each branchNumber = 2].
	branch3 := session readOneOf: GlorpBankBranch where: [:each | each branchNumber = 3].
	self deny: branch2 == branch3.
	self assert: (branches includes: branch2).
	self assert: (branches includes: branch3).