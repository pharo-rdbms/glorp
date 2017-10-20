tests
testCollect
	| ids |
	ids := vc collect: [:each | each id].
	
	self assert: ids size = 3.
	ids do: [:each | self assert: each isInteger].