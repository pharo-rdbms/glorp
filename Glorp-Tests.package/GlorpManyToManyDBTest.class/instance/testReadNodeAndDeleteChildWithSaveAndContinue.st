tests-nodes
testReadNodeAndDeleteChildWithSaveAndContinue
	"This exercises two things. First, there's a bug in save and continue with deleted objects resurrecting. Second, make sure that if we delete both parent and child, the link goes away"
	| node1 node3 links nodes node2 |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		node1 := session readOneOf: GlorpTreeNode where: [:each | each id = 1].
		node2 := (node1 children asSortedCollection: [:a :b | a id <= b id]) first.
		node3 := (node1 children asSortedCollection: [:a :b | a id <= b id]) last.
		session beginUnitOfWork.
			[session register: node1.
			session delete: node3.
			node1 children remove: node3] ensure: [session saveAndContinue].
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links size = 1.
		self assert: links first first = 1. 
		self assert: links first last = 2.
		nodes := session accessor executeSQLString: 'SELECT * FROM TREE_NODE'.
		self deny: (nodes anySatisfy: [:each | each first = node3 id]).
		self assert: nodes size = 2.

			[session register: node1.
			session delete: node2.
			session delete: node1] ensure: [session saveAndContinue].
		nodes := session accessor executeSQLString: 'SELECT * FROM TREE_NODE'.
		self assert: nodes isEmpty.
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links isEmpty.
		].