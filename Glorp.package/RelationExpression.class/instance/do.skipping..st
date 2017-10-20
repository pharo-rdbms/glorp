iterating
do: aBlock skipping: aSet
	| clauses |
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	leftChild hasImpliedClauses
		ifTrue:
			[clauses := leftChild allRelationsFor: self.
			clauses do: [:each | each do: aBlock skipping: aSet]]
		ifFalse:
			[leftChild do: aBlock skipping: aSet.
			rightChild do: aBlock skipping: aSet.
			aBlock value: self.].