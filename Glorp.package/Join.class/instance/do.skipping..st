iterating
do: aBlock skipping: aSet
	"Joins act as if they don't have children, and just evaluate for themselves"
	| |
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	aBlock value: self.