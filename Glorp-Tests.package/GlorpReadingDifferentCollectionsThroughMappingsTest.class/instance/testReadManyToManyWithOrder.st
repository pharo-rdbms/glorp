tests
testReadManyToManyWithOrder
	| thing list |
	session transact: [session register: GlorpThingWithLotsOfDifferentCollections exampleForOrdering].
	session reset.
	list := session read: GlorpThingWithLotsOfDifferentCollections.
	self assert: list size = 1.
	thing := list first.
	self assert: thing orderedCollection size = 6.
	self
		assert:
			(thing orderedCollection collect: [:each | each name]) asArray = #('oc6' 'oc5' 'oc4' 'oc3' 'oc7' 'oc8')