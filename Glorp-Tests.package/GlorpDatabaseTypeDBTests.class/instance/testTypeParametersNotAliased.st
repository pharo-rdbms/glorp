tests
testTypeParametersNotAliased

	| type2 type3 |
	type := (self platform) varchar.
	self assert: type width isNil.
	self assert: (type2 := self platform varChar: 5) width = 5.
	self assert: type width isNil.
	type3 := self platform varChar: 10.
	self assert: type3 width = 10.
	self assert: type2 width = 5.
	self assert: type width isNil.