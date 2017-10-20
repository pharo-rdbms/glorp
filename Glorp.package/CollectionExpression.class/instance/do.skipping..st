iterating
do: aBlock skipping: aSet
	"Because our argument is a block, and the thing passed to it is our left child, we can assume that our left child will be referenced via that block. So we'll ignore it. This will help when condensing out primary key expressions, because otherwise us iterating over them forces them to stay around."
	| |
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	rightChild do: aBlock skipping: aSet.
	aBlock value: self.