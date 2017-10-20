accessing
allSequencesFor: aCollection
	"Find all the sequences associated with aCollectionOfTables"
	| result |
	result := Dictionary new.
	aCollection do: [:each |
		each allSequences keysAndValuesDo: [:eachName :eachSequence |
				result at: eachName put: eachSequence]].
	^result