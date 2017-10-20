tests-relatedrows
testRelatedRowInternal
	| cf1 r1 r2 r3 |
	cf1 := t1 createFieldNamed: 'cf1' type: (platform varChar: 10).
	t1 addForeignKeyFrom: cf1 to: f1.
	rowMap
		unifyField: f1
		key: o1
		withField: cf1
		key: o2.
	rowMap
		unifyField: f1
		key: o1
		withField: cf1
		key: o3.
	r1 := rowMap rowForTable: t1 withKey: o1.
	r1 at: f1 put: o1.
	r2 := rowMap rowForTable: t1 withKey: o2.
	r2 at: f1 put: o2.
	r3 := rowMap rowForTable: t1 withKey: o3.
	r3 at: f1 put: o3.
	self assert: (r1 relatedRowsIn: rowMap) isEmpty.
	self assert: (r2 relatedRowsIn: rowMap) asArray = (Array with: r1).
	self assert: (r3 relatedRowsIn: rowMap) asArray = (Array with: r1).