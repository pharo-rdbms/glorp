tests-transformation
testUnifyWithTransformationAfterStoreInverse
	"This is a little tricky. If we set the value first, then impose the constraint, then we're effectively doubling what was set. I think this is actually right, but also a very weird case on top of weird scenarios to begin with"

	(rowMap findOrAddRowForTable: t2 withKey: o2) at: f2 put: 12.
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].	"Note: vs. the 6 and 12 you might otherwise expect"
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) = 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) = 24.