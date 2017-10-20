data
data1
	| one two three |
	one := GlorpBreadthFirstTopologicalSortItem new id: 1.
	two := GlorpBreadthFirstTopologicalSortItem new id: 2.
	three := GlorpBreadthFirstTopologicalSortItem new id: 3.
	one relateTo: two.
	two relateTo: three.
	^Array with: one with: two with: three.