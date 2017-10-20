accessing
sequences
	"Return a collection (which is likely either empty or of size 1) of all the sequences we use."
	| sequences |
	sequences := OrderedCollection new: 2.
	self primaryKeyFields do: [:each | each type hasSequence ifTrue: [sequences add: each type sequence]].
	^sequences.