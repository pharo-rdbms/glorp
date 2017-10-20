*Glorp-Tests
exampleForOrdering
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