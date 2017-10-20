tests-transformation
testUnifyExtraOnSourceSideWithTransformationBeforeStoreInverse
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	rowMap
		unifyField: f1
		key: o1
		withField: f3
		key: o3.
	(rowMap findOrAddRowForTable: t2 withKey: o2) at: f2 put: 24.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) = 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) = 24.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) = 12.