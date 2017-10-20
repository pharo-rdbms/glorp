tests
testStoreThenUnify
	rowMap at: f1 key: o1 put: 12.
	rowMap
		unifyField: f2
		key: o2
		withField: f3
		key: o3.
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) = 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) = 12.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) = 12.