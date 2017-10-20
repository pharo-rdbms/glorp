accessing
casesDo: aBlock
	"Iterate over all of our cases"
	cases do: [:each | aBlock value: each value].
	aBlock value: otherwiseCase