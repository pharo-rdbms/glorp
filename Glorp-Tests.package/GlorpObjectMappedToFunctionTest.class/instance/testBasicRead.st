tests
testBasicRead
	| branches |
	branches := session read: GlorpBankBranch.
	self assert: branches size = 3.
	self assert: (branches collect: [:each | each branchNumber]) asSortedCollection = #(2 3 712) asSortedCollection.