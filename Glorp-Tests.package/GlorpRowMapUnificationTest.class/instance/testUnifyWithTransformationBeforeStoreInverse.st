tests-transformation
testUnifyWithTransformationBeforeStoreInverse
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	rowMap at: f2 key: o2 put: 12.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) = 6.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) = 12.