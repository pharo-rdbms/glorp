accessing
allSequences
	"Return a dictionary of all the sequences associated with this table, indexed by name."

	| result |
	result := Dictionary new.
	self fields do: [:eachField | 
 		eachField type hasSequence ifTrue:
			[result at: eachField type sequence name put: eachField type sequence]].
	^result.