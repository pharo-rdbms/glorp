tests
testCollect
	self assert: (stream collect: [:each | each name]) = #('Alan' 'Bob' 'Carol').