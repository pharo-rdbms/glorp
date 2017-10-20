tests
testDoubleRowUnificationDifferentRows
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	rowMap
		unifyField: f3
		key: o3
		withField: f2
		key: o2.
	(rowMap rowForTable: t1 withKey: o1) at: f1 put: 42.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) = 42.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) = 42.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) = 42.