converting
asIndependentJoins
	| |
	"If this is an ANDed clause, referring to two different tables split it into independent joins"
	relation == #AND ifFalse: [^Array with: self].
	leftChild tablesForANSIJoin asSortedCollection = rightChild tablesForANSIJoin asSortedCollection
		ifTrue: [^Array with: self].
	^(Array with: leftChild with: rightChild) inject: OrderedCollection new into: [:sum :each |
		sum addAll: each asIndependentJoins. sum].