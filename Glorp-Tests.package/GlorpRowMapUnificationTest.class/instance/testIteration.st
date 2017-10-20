tests
testIteration

	| rows r1 r2 r3 count |
	r1 := rowMap findOrAddRowForTable: t1 withKey: o1.
	r2 := rowMap findOrAddRowForTable: t1 withKey: o2.
	r3 := rowMap findOrAddRowForTable: t2 withKey: o2.
	rows := IdentitySet new.
	count := 0.
	rowMap rowsDo: [:each | 
		count := count + 1.
		rows add: each].
	self assert: count = 3.
	self assert: (rows includes: r1).
	self assert: (rows includes: r3).
	self assert: (rows includes: r2).