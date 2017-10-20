tests-outer scope references
testRebuildDoubleInnerScopeNormallyWithExists
	original := [:each | 
	each foo
		anySatisfyExists:
			[:eachFoo | eachFoo things anySatisfyExists: [:eachThing | eachThing stuff = each fooThing]]]
		asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	rebuilt do: [:each | self assert: each ultimateBaseExpression == newBase].