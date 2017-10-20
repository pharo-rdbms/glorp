iterating
anySatisfy: aBlock
	"Answer true if aBlock answers true for any element of the receiver.
	 An empty collection answers false."

	self do: [:each| (aBlock value: each) ifTrue: [^true]].
	^false