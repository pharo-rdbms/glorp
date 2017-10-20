tests-transformation
testUnifyWithTransformationAfterStoreForward
	(rowMap findOrAddRowForTable: t1 withKey: o1) at: f1 put: 12.
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) = 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) = 24.