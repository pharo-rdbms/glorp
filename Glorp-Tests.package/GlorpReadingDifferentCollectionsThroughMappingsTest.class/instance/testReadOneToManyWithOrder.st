tests
testReadOneToManyWithOrder
	| thing list |
	session transact: [session register: GlorpThingWithLotsOfDifferentCollections exampleForOrdering].
	session reset.
	list := session read: GlorpThingWithLotsOfDifferentCollections.
	self assert: list size = 1.
	thing := list first.
	self assert: thing array size = 6.
	self
		assert:
			(thing array collect: [:each | each name]) asArray = #('a1' 'a2' 'a3' 'a9' 'a8' 'a7')