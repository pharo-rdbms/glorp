tests-nodes
writeNodeWithChildren
	| node1 node2 node2a |
	node1 := self treeNodeClass new id: 1.
	node2 := self treeNodeClass new id: 2.
	node2a := self treeNodeClass new id: 3.
	node1 children add: node2.
	node1 children add: node2a.
	session inUnitOfWorkDo: [session register: node1].