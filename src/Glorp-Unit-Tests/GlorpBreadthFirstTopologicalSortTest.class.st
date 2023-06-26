Class {
	#name : #GlorpBreadthFirstTopologicalSortTest,
	#superclass : #TestCase,
	#instVars : [
		'unsorted',
		'sorted',
		'groupA',
		'groupB',
		'groupC'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #asserting }
GlorpBreadthFirstTopologicalSortTest >> assertSortOrder: aCollection [

	| ids |
	ids := (sorted collect: [ :each | each id ]) asArray.
	self assert: ids equals: aCollection asArray
]

{ #category : #data }
GlorpBreadthFirstTopologicalSortTest >> data1 [

	| one two three |
	one := GlorpBreadthFirstTopologicalSortItem new id: 1.
	two := GlorpBreadthFirstTopologicalSortItem new id: 2.
	three := GlorpBreadthFirstTopologicalSortItem new id: 3.
	one relateTo: two.
	two relateTo: three.
	^ Array with: one with: two with: three
]

{ #category : #data }
GlorpBreadthFirstTopologicalSortTest >> dataForGroupNamed: aString [

	| one two three four |
	one := GlorpBreadthFirstTopologicalSortItem new id: aString, '1'.
	two := GlorpBreadthFirstTopologicalSortItem new id: aString, '2'.
	three := GlorpBreadthFirstTopologicalSortItem new id: aString, '3'.
	four := GlorpBreadthFirstTopologicalSortItem new id: aString, '4'.
	^Array with: one with: two with: three with: four
]

{ #category : #data }
GlorpBreadthFirstTopologicalSortTest >> dataForMedium [
	"Data to ensure that things tend to stay together.  This is a simple grouping a1->b, b->c, b->a2, repeated, with some extra floating b's and c's."

	groupA := self dataForGroupNamed: 'a'.
	groupB := self dataForGroupNamed: 'b'.
	groupC := self dataForGroupNamed: 'c'.
	groupA first relateTo: groupB first.
	(groupA at: 3) relateTo: (groupB at: 3).
	groupB first relateTo: groupC first.
	(groupB at: 3) relateTo: (groupC at: 3).
	groupB first relateTo: (groupA at: 2).
	(groupB at: 3) relateTo: (groupA at: 4).
	^groupA, groupB, groupC
]

{ #category : #data }
GlorpBreadthFirstTopologicalSortTest >> dataForNoCyclesMedium [
	"Data to ensure that things tend to stay together.  This is a simple grouping a->b, b->c repeated"

	groupA := self dataForGroupNamed: 'a'.
	groupB := self dataForGroupNamed: 'b'.
	groupC := self dataForGroupNamed: 'c'.
	1 to: 4 do: [:i |
		(groupA at: i) relateTo: (groupB at: i).
		(groupB at: i) relateTo: (groupC at: i)].
	^groupC, groupB, groupA
]

{ #category : #data }
GlorpBreadthFirstTopologicalSortTest >> dataForNoCyclesMediumPermuted [
	"Data to ensure that things tend to stay together.  This is a simple grouping a->b, b->c repeated"

	groupA := self dataForGroupNamed: 'a'.
	groupB := self dataForGroupNamed: 'b'.
	groupC := self dataForGroupNamed: 'c'.
	1 to: 4 do: [:i |
		(groupA at: i) relateTo: (groupB at: i).
		(groupB at: i) relateTo: (groupC at: i)].
	^groupB, groupA, groupC
]

{ #category : #support }
GlorpBreadthFirstTopologicalSortTest >> sort [

	| sorter |
	sorter := GlorpRowSorter new getChildrenVia: #relatedItems.
	sorted := sorter sort: unsorted
]

{ #category : #support }
GlorpBreadthFirstTopologicalSortTest >> sort: aCollection [

	unsorted := aCollection.
	self sort
]

{ #category : #tests }
GlorpBreadthFirstTopologicalSortTest >> testBasicSort1 [

	self sort: self data1.
	self assertSortOrder: #( 3 2 1 )
]

{ #category : #tests }
GlorpBreadthFirstTopologicalSortTest >> testBasicSort2 [
	"Try it with a different initial order. The sort is a convoluted way of writing the questionably-portable reverse"

	self sort: (self data1 asSortedCollection: [ :a :b | a id >= b id ]).
	self assertSortOrder: #( 3 2 1 )
]

{ #category : #tests }
GlorpBreadthFirstTopologicalSortTest >> testBasicSortCompleteGraph [

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
	self assert: sorted size equals: 3
]

{ #category : #tests }
GlorpBreadthFirstTopologicalSortTest >> testMedium1 [

	self sort: self dataForMedium.
	self assertSortOrder:
		#( 'c1' 'a2' 'b1' 'a1' 'c3' 'a4' 'b3' 'a3' 'b2' 'b4' 'c2' 'c4' )
]

{ #category : #tests }
GlorpBreadthFirstTopologicalSortTest >> testNoCyclesMedium [

	self sort: self dataForNoCyclesMedium.
	self assertSortOrder:
		#( 'c1' 'c2' 'c3' 'c4' 'b1' 'b2' 'b3' 'b4' 'a1' 'a2' 'a3' 'a4' )
]

{ #category : #tests }
GlorpBreadthFirstTopologicalSortTest >> testNoCyclesMediumPermuted [

	self sort: self dataForNoCyclesMediumPermuted.
	self assertSortOrder: #('c1' 'b1' 'c2' 'b2' 'c3' 'b3' 'c4' 'b4' 'a1' 'a2' 'a3' 'a4')
]
