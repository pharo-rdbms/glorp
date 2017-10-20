iterating
do: aBlock skipping: aSet
	"Iterate over the expression tree"

	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	base do: aBlock skipping: aSet.
	aBlock value: self.