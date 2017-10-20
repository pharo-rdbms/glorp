tests-outer scope references
testRebuildInnerScopeForSubquery

	| foo |
	original := [:each | each foo anySatisfyJoin: [:eachFoo | eachFoo thing = each fooThing]] asGlorpExpression.
	"Just so that it prints distinctively"
	original ultimateBaseExpression descriptor: (Descriptor new classModel: (GlorpClassModel for: Object)).
	foo := original leftChild.
	newBase := SubSelectBaseExpression on: foo.
	rebuilt := original rightChild rebuildOn: newBase startingFrom: foo.
	self assert: rebuilt leftChild base == newBase.
	self assert: rebuilt leftChild ultimateBaseExpression == original ultimateBaseExpression.
	self assert: rebuilt rightChild base == original ultimateBaseExpression.