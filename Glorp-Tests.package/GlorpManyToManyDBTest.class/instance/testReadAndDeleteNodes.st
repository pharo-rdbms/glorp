tests-nodes
testReadAndDeleteNodes
	"Make sure we don't delete out of order and that links disappear."
	| nodes links |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		session transact: [
			nodes := session read: GlorpTreeNode.
			nodes do: [:each | session delete: each]].
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links size = 0].