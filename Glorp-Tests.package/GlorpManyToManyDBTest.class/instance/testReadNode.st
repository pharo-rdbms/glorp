tests-nodes
testReadNode
	| allNodes |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		allNodes := session read: GlorpTreeNode orderBy: #id.
		self assert: (allNodes collect: [:each | each id]) asArray = #( 1 2 3).
		self assert: allNodes first children size = 2.
		self assert: (allNodes first children collect: [:each | each id]) asSortedCollection asArray = #( 2 3)].