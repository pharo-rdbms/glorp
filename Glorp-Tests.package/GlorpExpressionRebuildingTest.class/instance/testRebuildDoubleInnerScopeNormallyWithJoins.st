tests-outer scope references
testRebuildDoubleInnerScopeNormallyWithJoins
	original := [:each | 
	each foo
		anySatisfyJoin:
			[:eachFoo | eachFoo things anySatisfyJoin: [:eachThing | eachThing stuff = each fooThing]]]
		asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	rebuilt do: [:each | self assert: each ultimateBaseExpression == newBase].