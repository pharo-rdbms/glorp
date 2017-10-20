tests
testLargeClob
	"The long test here not only fails, it messes up the driver so that other tests fail"
	self platform isUDBCSQLite3Platform ifTrue: [ ^ self skip. ].
	"(session platform class == AccessPlatform and: [session useBinding not])
		ifTrue: [^self]."
	self helpTestValue: self longString.