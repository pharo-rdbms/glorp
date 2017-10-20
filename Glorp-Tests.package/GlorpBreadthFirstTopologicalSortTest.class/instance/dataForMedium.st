data
dataForMedium
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
	^groupA, groupB, groupC.