tests-outer scope references
testRebuildInnerScopeNormally
	original := [:each | each foo anySatisfy: [:eachFoo | eachFoo thing = each fooThing]]
		asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	rebuilt do: [:each | self assert: each ultimateBaseExpression == newBase].