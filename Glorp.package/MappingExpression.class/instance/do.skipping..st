iterating
do: aBlock skipping: aSet
	"Iterate over the expression tree"

	| myField |
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	base do: aBlock skipping: aSet.
	aBlock value: self.
	(self hasField and: [(myField := self field) isGlorpExpression])
		ifTrue: [myField do: aBlock skipping: aSet].