tests
testAllClassesAndNames
	| identity1 identity2 identity3 |
	system flushAllClasses.
	identity1 := system allClasses.
	identity2 := system allClasses.
	system flushAllClasses.
	identity3 := system allClasses.
	self assert: identity1 == identity2.
	self assert: identity1 ~~ identity3.
	self should: [system allClassNames] raise: Dialect error.