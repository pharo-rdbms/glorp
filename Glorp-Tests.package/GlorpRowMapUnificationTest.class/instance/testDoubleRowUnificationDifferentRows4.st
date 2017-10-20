tests
testDoubleRowUnificationDifferentRows4
	| t4 f4 o4 |
	t4 := DatabaseTable named: 'T4'.
	f4 := t4 createFieldNamed: 'f4' type: (platform varChar: 10).
	o4 := 'four'.
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	rowMap
		unifyField: f3
		key: o3
		withField: f4
		key: o4.
	rowMap
		unifyField: f2
		key: o2
		withField: f3
		key: o3.
	(rowMap rowForTable: t1 withKey: o1) at: f1 put: 42.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) = 42.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) = 42.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) = 42.
	self assert: ((rowMap rowForTable: t4 withKey: o4) at: f4) = 42.