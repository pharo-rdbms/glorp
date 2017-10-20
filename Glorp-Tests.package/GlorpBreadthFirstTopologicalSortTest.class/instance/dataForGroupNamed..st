data
dataForGroupNamed: aString
	| one two three four |
	one := GlorpBreadthFirstTopologicalSortItem new id: aString, '1'.
	two := GlorpBreadthFirstTopologicalSortItem new id: aString, '2'.
	three := GlorpBreadthFirstTopologicalSortItem new id: aString, '3'.
	four := GlorpBreadthFirstTopologicalSortItem new id: aString, '4'.
	^Array with: one with: two with: three with: four.