*Glorp-Tests
example1
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