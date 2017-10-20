tests
testBasicSortCompleteGraph
	| one two three |
	one := GlorpBreadthFirstTopologicalSortItem new id: 1.
	two := GlorpBreadthFirstTopologicalSortItem new id: 2.
	three := GlorpBreadthFirstTopologicalSortItem new id: 3.
	one relateTo: two.
	one relateTo: three.
	three relateTo: two.
	three relateTo: one.
	two relateTo: three.
	two relateTo: one.
	self sort: (Array with: one with: two with: three).
	self assert: sorted size = 3.