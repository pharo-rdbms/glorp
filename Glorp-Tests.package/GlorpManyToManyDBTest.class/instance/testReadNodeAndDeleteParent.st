tests-nodes
testReadNodeAndDeleteParent
	| node1 links |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		session transact: [
		node1 := session readOneOf: GlorpTreeNode where: [:each | each id = 1].
		session delete: node1.
		node1 children: #()].
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links size = 0].