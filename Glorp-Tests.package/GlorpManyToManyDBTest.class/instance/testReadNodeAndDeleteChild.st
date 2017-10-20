tests-nodes
testReadNodeAndDeleteChild
	| node1 node3 links nodes |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		node1 := session readOneOf: GlorpTreeNode where: [:each | each id = 1].
		node3 := (node1 children asSortedCollection: [:a :b | a id <= b id]) last.
		session transact: [
			session register: node1.
			session delete: node3.
			node1 children remove: node3].
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links size = 1.
		self assert: links first first = 1. 
		self assert: links first last = 2.
		nodes := session accessor executeSQLString: 'SELECT * FROM TREE_NODE'.
		self deny: (nodes anySatisfy: [:each | each first = node3 id]).
		self assert: nodes size = 2
		].