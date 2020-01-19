Extension { #name : #GlorpThingWithLotsOfDifferentCollections }

{ #category : #'*Glorp-Tests' }
GlorpThingWithLotsOfDifferentCollections class >> example1 [
	| example array |
	example := self new.
	example name: 'fred'.
	array := Array with: (GlorpThingOne named: 'array1') with: (GlorpThingOne named: 'array2') with: (GlorpThingOne named: 'array3').
	example array: array.
	example set add: (GlorpThingOne named: 'set1').
	example set add: (GlorpThingOne named: 'set2').	
	example orderedCollection add: (GlorpThingOne named: 'orderedCollection1').
	example orderedCollection add: (GlorpThingOne named: 'orderedCollection2').
	example bag add: (GlorpThingOne named: 'bag1').
	example bag add: (GlorpThingOne named: 'bag2').
	example sortedCollection add: (GlorpThingOne named: 'sorted1').
	example sortedCollection add: (GlorpThingOne named: 'sorted2').
	example sortedCollection add: (GlorpThingOne named: 'sorted3').
	example sortedCollection add: (GlorpThingOne named: 'sorted4').
	^example.
]

{ #category : #'*Glorp-Tests' }
GlorpThingWithLotsOfDifferentCollections class >> exampleForOrdering [
	| example |
	example := self new.
	example name: 'order'.
	example orderedCollection add: (GlorpThingOne named: 'oc6').
	example orderedCollection add: (GlorpThingOne named: 'oc5').
	example orderedCollection add: (GlorpThingOne named: 'oc4').
	example orderedCollection add: (GlorpThingOne named: 'oc3').
	example orderedCollection add: (GlorpThingOne named: 'oc7').
	example orderedCollection add: (GlorpThingOne named: 'oc8').
	example array: (#('a1' 'a2' 'a3' 'a9' 'a8' 'a7') collect: [:each | GlorpThingOne named: each]).
	^example
]

{ #category : #'*Glorp-Tests' }
GlorpThingWithLotsOfDifferentCollections class >> new [
	"Answer a newly created and initialized instance."

	^super new initialize
]
