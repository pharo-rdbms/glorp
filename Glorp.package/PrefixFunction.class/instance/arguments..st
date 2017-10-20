accessing
arguments: aCollection
	"Our arguments may have already been set to a block, in which case we evaluate it with the incoming collection."
	argumentModifierBlock notNil ifTrue: [^arguments := argumentModifierBlock value: self value: aCollection].
	arguments := aCollection.