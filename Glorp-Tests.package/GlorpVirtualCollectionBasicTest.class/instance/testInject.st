tests
testInject
	| sumofIds |
	sumofIds := vc inject: 0 into: [:sum :each | sum + each id].
	self assert: sumofIds = (86 + 87 + 88).