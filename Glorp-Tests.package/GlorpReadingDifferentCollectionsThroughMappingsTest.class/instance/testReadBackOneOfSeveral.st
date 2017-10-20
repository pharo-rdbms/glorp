tests
testReadBackOneOfSeveral
	"Some dialects (e.g. VA) inline yourself so we must send yourSelf."

	| thing list |
	self writeMore.
	session reset.
	list := session read: GlorpThingWithLotsOfDifferentCollections where: [:each | each name = 'fred'].
	self assert: list size = 1.
	thing := list first.
	self assert: thing array size = 3.
	self
		assert:
			(self validateFor: thing array against: #('array1' 'array2' 'array3')).
	self assert: thing array yourSelf class = Array.
	self assert: thing set size = 2.
	self assert: thing set yourSelf class = Set.
	self assert: (self validateFor: thing set against: #('set1' 'set2')).
	self assert: thing orderedCollection size = 2.
	self assert: thing orderedCollection yourSelf class = OrderedCollection.
	self
		assert:
			(self
				validateFor: thing orderedCollection
				against: #('orderedCollection1' 'orderedCollection2')).
	self assert: thing bag size = 2.
	self assert: thing bag yourSelf class = Bag.
	self assert: (self validateFor: thing bag against: #('bag1' 'bag2')).
	self assert: thing sortedCollection size = 4.
	self assert: thing sortedCollection yourSelf class = SortedCollection.
	self assert:
			(thing sortedCollection collect: [:each | each name]) asArray
				= #('sorted1' 'sorted2' 'sorted3' 'sorted4').