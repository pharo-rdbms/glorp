data
dataForNoCyclesMedium
	"Data to ensure that things tend to stay together.  This is a simple grouping a->b, b->c repeated"
	groupA := self dataForGroupNamed: 'a'.
	groupB := self dataForGroupNamed: 'b'.
	groupC := self dataForGroupNamed: 'c'.
	1 to: 4 do: [:i |
		(groupA at: i) relateTo: (groupB at: i).
		(groupB at: i) relateTo: (groupC at: i)].
	^groupC, groupB, groupA.