support
testRelationships
	| branch accounts |
	branch := session readOneOf: GlorpBankBranch where: [:each | each branchNumber = 2].
	accounts := branch accounts yourself.
	self assert: accounts size = 1.
	self assert: accounts first id = 9874.